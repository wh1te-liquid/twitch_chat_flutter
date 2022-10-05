part of 'chat_bloc.dart';

@immutable
abstract class ChatEvent {}

class ChatReceiveMessage extends ChatEvent {
  final String? data;
  final Message? notice;

  ChatReceiveMessage({this.data, this.notice});
}

class ChatUpdateScrollPosition extends ChatEvent {}

class ChatResumeAutoScroll extends ChatEvent {}
