// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:twitch_chat_flutter/utils/hex_color.dart';

class Tags {
  final Map? badges;
  final Map? emotes;
  final Color color;
  final String? displayName;
  final String? emoteOnly;
  final String? id;
  final String? mod;
  final String? roomId;
  final String? subscriber;
  final String? turbo;
  final String? tmiSentTs;
  final String? userId;
  final String? userType;

  Tags({
    required this.badges,
    required this.emotes,
    required this.color,
    required this.displayName,
    required this.emoteOnly,
    required this.id,
    required this.mod,
    required this.roomId,
    required this.subscriber,
    required this.turbo,
    required this.tmiSentTs,
    required this.userId,
    required this.userType,
  });

  factory Tags.fromJson(Map<String, dynamic> json) {
    return Tags(
      badges: json['badges'],
      emotes: json['emotes'],
      color: json['color'] == null
          ? Colors.primaries[Random().nextInt(Colors.primaries.length)]
          : HexColor(json['color']!),
      displayName: json['display-name'],
      emoteOnly: json['emote-only'],
      id: json['id'],
      mod: json['mod'],
      roomId: json['room-id'],
      subscriber: json['subscriber'],
      turbo: json['turbo'],
      tmiSentTs: json['tmi-sent-ts'],
      userId: json['user-id'],
      userType: json['user-type'],
    );
  }
}
