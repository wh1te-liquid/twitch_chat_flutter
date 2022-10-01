import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitch_chat_flutter/models/message.dart';
import 'package:twitch_chat_flutter/repositories/twitch_irc_client.dart';
import 'package:twitch_chat_flutter/utils/twitch_message_parser.dart';

part 'chat_event.dart';

part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  StreamSubscription? chatSubscription;

  ChatBloc({required TwitchIrcClient client})
      : super(const ChatState(messages: [])) {
    chatSubscription = client.stream?.listen((data) {
      add(ChatReceiveMessage(data));
    });

    on<ChatReceiveMessage>(
        (event, emit) => processMessage(data: event.data, emit: emit));
  }

  void processMessage({
    String? data,
    required Emitter<ChatState> emit,
  }) {
    if (data == null) return;
    final parsedRawMessage = parseMessage(data);
    if (parsedRawMessage != null) {
      final message = Message.fromJson(parsedRawMessage);
      List<Message> messages = [...state.messages];
      if (messages.length <= 150) {
        messages.insert(0, message);
      } else {
        messages.removeAt(messages.length - 1);
        messages.insert(0, message);
      }
      emit(state.copyWith(messages: messages));
    }
  }

  @override
  Future<Function> close() async {
    chatSubscription?.cancel();
    return super.close;
  }
}
