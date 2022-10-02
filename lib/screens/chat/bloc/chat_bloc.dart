// Dart imports:
import 'dart:async';
import 'dart:developer';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:twitch_chat_flutter/models/message.dart';
import 'package:twitch_chat_flutter/repositories/twitch_irc_client.dart';
import 'package:twitch_chat_flutter/utils/twitch_message_parser.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final int renderMessagesLimit = 150;
  StreamSubscription? chatSubscription;

  ChatBloc({required TwitchIrcClient client})
      : super(ChatState(
          scrollController: ScrollController(),
          autoScroll: true,
          messages: const [],
          messageBuffer: const [],
        )) {
    chatSubscription = client.stream?.listen(
        (data) {
          add(ChatReceiveMessage(data));
        },
        onError: (error) => log('Chat error: ${error.toString()}'),
        onDone: () {
          log('done');
        });

    state.scrollController.addListener(() {
      add(ChatUpdateScrollPosition());
    });

    on<ChatReceiveMessage>(
        (event, emit) => processMessage(data: event.data, emit: emit));
    on<ChatUpdateScrollPosition>((event, emit) => toggleAutoScroll(emit: emit));
    on<ChatResumeAutoScroll>((event, emit) => resumeScroll(emit: emit));
  }

  void processMessage({
    String? data,
    required Emitter<ChatState> emit,
  }) {
    if (data == null) return;
    final parsedRawMessage = parseMessage(data);
    if (parsedRawMessage != null) {
      final message = Message.fromJson(parsedRawMessage, data);
      if (message.tags == null || message.source?.nick == null) {
        log("tag == null or nick null");
        return;
      }
      List<Message> messages = [
        ...state.autoScroll ? state.messages : state.messageBuffer
      ];
      if (!state.autoScroll) {
        messages.add(message);
        emit(state.copyWith(messageBuffer: messages));
        return;
      }
      if (messages.length <= renderMessagesLimit) {
        messages.insert(0, message);
      } else {
        messages.removeAt(messages.length - 1);
        messages.insert(0, message);
      }
      emit(state.copyWith(messages: messages));
    }
  }

  void toggleAutoScroll({
    required Emitter<ChatState> emit,
  }) {
    final position = state.scrollController.position.pixels;
    bool value = state.autoScroll;
    if (position <= 0) {
      value = true;
    } else if (position <= renderMessagesLimit) {
      addMessagesFromBuffer(emit: emit);
    } else if (position > 0) {
      value = false;
    }
    if (state.autoScroll != value) {
      emit(state.copyWith(autoScroll: value));
    }
  }

  void resumeScroll({
    required Emitter<ChatState> emit,
  }) {
    addMessagesFromBuffer(emit: emit);
    emit(state.copyWith(autoScroll: true));

    state.scrollController.jumpTo(0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      state.scrollController.jumpTo(0);
    });
  }

  void addMessagesFromBuffer({
    required Emitter<ChatState> emit,
  }) {
    List<Message> messages = [...state.messages];
    if (state.messageBuffer.length > renderMessagesLimit) {
      messages = state.messageBuffer
          .sublist(state.messageBuffer.length - renderMessagesLimit);
    } else {
      messages.addAll(state.messageBuffer);
      if (messages.length > renderMessagesLimit) {
        messages = messages.sublist(messages.length - renderMessagesLimit);
      }
    }
    emit(state.copyWith(
      messages: messages,
      messageBuffer: [],
    ));
  }

  @override
  Future<Function> close() async {
    chatSubscription?.cancel();
    return super.close;
  }
}
