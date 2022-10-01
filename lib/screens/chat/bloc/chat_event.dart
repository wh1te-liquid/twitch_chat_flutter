part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class ChatReceiveMessage extends ChatEvent {
  final String? data;

  ChatReceiveMessage(this.data);
}
