import 'package:flutter/material.dart';
import 'package:twitch_chat_flutter/models/message.dart';
import 'package:twitch_chat_flutter/utils/hex_color.dart';

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
              text: message.source?.nick ?? 'null',
              style: TextStyle(
                  color: message.tags?.color == null
                      ? null
                      : HexColor(message.tags!.color!))),
          TextSpan(text: ': ${message.parameters}'),
        ],
      ),
    );
  }
}
