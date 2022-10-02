// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:twitch_chat_flutter/models/message.dart';

class MessageCard extends StatelessWidget {
  final Message message;

  const MessageCard({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.white,
        ),
        children: <TextSpan>[
          TextSpan(
            text: message.source?.nick,
            style: TextStyle(
              color: message.tags?.color,
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: ': ${message.parameters}'),
        ],
      ),
    );
  }
}
