// Dart imports:
import 'dart:async';
import 'dart:developer';

// Package imports:
import 'package:web_socket_channel/io.dart';

class TwitchIrcClient {
  IOWebSocketChannel? _channel;
  String? _lastConnected;
  StreamSubscription? _chatSubscription;
  int _reconnectCooldown = 0;
  int _retriesCounter = 0;

  StreamSubscription? get chatSubscription => _chatSubscription;

  int get reconnectCooldown => _reconnectCooldown;

  int get retriesCounter => _retriesCounter;

  String? get lastConnected => _lastConnected;

  IOWebSocketChannel? get channel => _channel;

  Stream? get stream => _channel?.stream;

  bool get ircConnected => _channel != null;

  void connectToIRC({
    required String accessToken,
    String? channel,
    Function(dynamic)? onData,
    Function()? onCancel,
  }) {
    if (accessToken.isEmpty) return;
    _channel?.sink.close(1001);
    _channel =
        IOWebSocketChannel.connect(Uri.parse('wss://irc-ws.chat.twitch.tv:443'))
          ..sink.add(
              'CAP REQ :twitch.tv/membership twitch.tv/tags twitch.tv/commands')
          ..sink.add('PASS oauth:$accessToken')
          ..sink.add('NICK wh1telqd');
    connectToChat(channel: channel);
    if (onData != null && onCancel != null) {
      updateListener(
          accessToken: accessToken, onData: onData, onCancel: onCancel);
    }
  }

  void connectToChat({String? channel}) {
    if (!ircConnected) return;
    channel = channel ?? _lastConnected;
    _channel!.sink.add('JOIN #$channel');
    _lastConnected = channel;
  }

  void closeChat() {
    _channel!.sink.add('PART #$_lastConnected');
  }

  void updateListener({
    required String accessToken,
    required Function(dynamic) onData,
    required Function() onCancel,
  }) {
    _chatSubscription = _channel?.stream.listen(onData,
        onError: (error) => log('Chat error: ${error.toString()}'),
        onDone: () async {
          onCancel();
          await Future.delayed(Duration(seconds: _reconnectCooldown));
          _reconnectCooldown == 0
              ? _reconnectCooldown++
              : _reconnectCooldown *= 2;
          _retriesCounter++;
          _chatSubscription?.cancel();
          connectToIRC(
            accessToken: accessToken,
            onData: onData,
            onCancel: onCancel,
          );
        });
  }
}
