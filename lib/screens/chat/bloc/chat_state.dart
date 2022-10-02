part of 'chat_bloc.dart';

@immutable
class ChatState {
  final ScrollController _scrollController;
  final bool _autoScroll;
  final List<Message> _messages;
  final List<Message> _messageBuffer;

  const ChatState({
    required ScrollController scrollController,
    required bool autoScroll,
    required List<Message> messages,
    required List<Message> messageBuffer,
  })  : _scrollController = scrollController,
        _autoScroll = autoScroll,
        _messages = messages,
        _messageBuffer = messageBuffer;

  List<Message> get messages => _messages;

  ScrollController get scrollController => _scrollController;

  bool get autoScroll => _autoScroll;

  List<Message> get messageBuffer => _messageBuffer;

  ChatState copyWith({
    List<Message>? messages,
    List<Message>? messageBuffer,
    ScrollController? scrollController,
    bool? autoScroll,
  }) {
    return ChatState(
      scrollController: scrollController ?? _scrollController,
      messages: messages ?? _messages,
      messageBuffer: messageBuffer ?? _messageBuffer,
      autoScroll: autoScroll ?? _autoScroll,
    );
  }
}
