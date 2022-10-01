part of 'chat_bloc.dart';

@immutable
class ChatState {
  final List<Message> _messages;

  const ChatState({
    required List<Message> messages,
  })  :
        _messages = messages;


  List<Message> get messages => _messages;

  ChatState copyWith({List<Message>? messages}) {
    return ChatState(
      messages: messages ?? _messages,
    );
  }
}
