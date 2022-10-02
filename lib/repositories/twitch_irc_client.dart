// Package imports:
import 'package:web_socket_channel/io.dart';

class TwitchIrcClient {
  IOWebSocketChannel? _channel;
  String? _lastConnected;

  Stream? get stream => _channel?.stream;

  bool get ircConnected => _channel != null;

  void connectToIRC({
    required String accessToken,
  }) {
    if (accessToken.isEmpty) return;
    _channel =
        IOWebSocketChannel.connect(Uri.parse('wss://irc-ws.chat.twitch.tv:443'))
          ..sink.add(
              'CAP REQ :twitch.tv/membership twitch.tv/tags twitch.tv/commands')
          ..sink.add('PASS oauth:$accessToken')
          ..sink.add('NICK wh1telqd');
  }

  void connectToChat({required String username}) {
    if (!ircConnected) return;
    _channel!.sink.add('JOIN #$username');
    _lastConnected = username;
  }

  void closeChat() {
    _channel!.sink.add('PART #$_lastConnected');
  }
}
