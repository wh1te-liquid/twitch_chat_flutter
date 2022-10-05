// Dart imports:
import 'dart:async';

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
  final int _renderMessagesLimit = 150;
  StreamSubscription? _chatSubscription;

  ChatBloc({required TwitchIrcClient client, required String accessToken})
      : super(ChatState(
          scrollController: ScrollController(),
          autoScroll: true,
          messages: const [],
          messageBuffer: const [],
        )) {
    client.updateListener(
      accessToken: accessToken,
      onData: (data) {
        add(ChatReceiveMessage(data: data));
      },
      onCancel: () {
        if (client.reconnectCooldown > 0) {
          final notice =
              'Disconnected from chat, waiting ${client.reconnectCooldown} ${client.reconnectCooldown == 1 ? 'second' : 'seconds'} before reconnecting...';
          add(ChatReceiveMessage(
              notice: Message.createNotice(message: notice)));
        }
        add(ChatReceiveMessage(
            notice: Message.createNotice(
                message:
                    'Reconnecting to chat (attempt ${client.retriesCounter})...')));
      },
    );
    state.scrollController.addListener(() {
      add(ChatUpdateScrollPosition());
    });

    on<ChatReceiveMessage>((event, emit) =>
        processMessage(data: event.data, notice: event.notice, emit: emit));
    on<ChatUpdateScrollPosition>((event, emit) => toggleAutoScroll(emit: emit));
    on<ChatResumeAutoScroll>((event, emit) => resumeScroll(emit: emit));
  }

  void processMessage({
    String? data,
    Message? notice,
    required Emitter<ChatState> emit,
  }) {
    Message? message;
    if (notice != null) {
      message = notice;
    } else {
      final parsedRawMessage = parseMessage(data!);
      if (parsedRawMessage != null) {
        message = Message.fromJson(parsedRawMessage, data);
      }
    }
    if (message == null) return;
    List<Message> messages = [
      ...state.autoScroll ? state.messages : state.messageBuffer
    ];
    if (message.parameters.contains('Welcome, GLHF')) {
      message = Message.createNotice(message: 'Connecting to chat...');
    }
    if (!state.autoScroll) {
      messages.add(message);
      emit(state.copyWith(messageBuffer: messages));
      return;
    }
    if (messages.length <= _renderMessagesLimit) {
      messages.insert(0, message);
    } else {
      messages.removeAt(messages.length - 1);
      messages.insert(0, message);
    }
    emit(state.copyWith(messages: messages));
  }

  void toggleAutoScroll({
    required Emitter<ChatState> emit,
  }) {
    final position = state.scrollController.position.pixels;
    bool value = state.autoScroll;
    if (position <= 0) {
      value = true;
    } else if (position <= _renderMessagesLimit) {
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
    if (state.messageBuffer.length > _renderMessagesLimit) {
      messages = state.messageBuffer
          .sublist(state.messageBuffer.length - _renderMessagesLimit);
    } else {
      messages.addAll(state.messageBuffer);
      if (messages.length > _renderMessagesLimit) {
        messages = messages.sublist(messages.length - _renderMessagesLimit);
      }
    }
    emit(state.copyWith(
      messages: messages,
      messageBuffer: [],
    ));
  }

  @override
  Future<Function> close() async {
    _chatSubscription?.cancel();
    return super.close;
  }
}
