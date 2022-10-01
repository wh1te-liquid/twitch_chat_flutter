import 'package:twitch_chat_flutter/models/command.dart';
import 'package:twitch_chat_flutter/models/source.dart';
import 'package:twitch_chat_flutter/models/tags.dart';

class Message {
  final Tags? tags;
  final Source? source;
  final Command command;
  final String parameters;

  Message({
    required this.tags,
    required this.source,
    required this.command,
    required this.parameters,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    if (json["tags"] != null) {
      json["tags"] = Map<String, dynamic>.from(json["tags"]);
    }
    if (json["source"] != null) {
      json["source"] = Map<String, dynamic>.from(json["source"]);
    }
    if (json["command"] != null) {
      json["command"] = Map<String, dynamic>.from(json["command"]);
    }
    return Message(
      tags: json['tags'] == null ? null : Tags.fromJson(json['tags']),
      source: json['source'] == null ? null : Source.fromJson(json['source']),
      command: Command.fromJson(json['command']),
      parameters: json['parameters'],
    );
  }
}
