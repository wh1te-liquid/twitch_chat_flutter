// Dart imports:
import 'dart:developer';

// Project imports:
import 'package:twitch_chat_flutter/models/source.dart';
import 'package:twitch_chat_flutter/models/tags.dart';

enum CommandKind {
  privateMessage,
  clearChat,
  clearMessage,
  notice,
  userNotice,
  roomState,
  userState,
  globalUserState,
  none,
}

class Message {
  final Tags? tags;
  final Source? source;
  final CommandKind command;
  final String parameters;
  final String json;

  Message({
    required this.json,
    this.tags,
    this.source,
    required this.command,
    required this.parameters,
  });

  factory Message.fromJson(Map<String, dynamic> json, String rawData) {
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
      json: rawData.toString(),
      tags: json['tags'] == null ? null : Tags.fromJson(json['tags']),
      source: json['source'] == null ? null : Source.fromJson(json['source']),
      command: getMessageKind(command: json['command']['command']),
      parameters: json['parameters'] ?? 'null',
    );
  }

  factory Message.createNotice({required String message}) => Message(
        command: CommandKind.userNotice,
        parameters: message,
        json: '',
      );
}

CommandKind getMessageKind({required String command}) {
  final CommandKind messageCommand;
  switch (command) {
    case 'PRIVMSG':
      messageCommand = CommandKind.privateMessage;
      break;
    case 'CLEARCHAT':
      messageCommand = CommandKind.clearChat;
      break;
    case 'CLEARMSG':
      messageCommand = CommandKind.clearMessage;
      break;
    case 'NOTICE':
      messageCommand = CommandKind.notice;
      break;
    case 'USERNOTICE':
      messageCommand = CommandKind.userNotice;
      break;
    case 'ROOMSTATE':
      messageCommand = CommandKind.roomState;
      break;
    case 'USERSTATE':
      messageCommand = CommandKind.userState;
      break;
    case 'GLOBALUSERSTATE':
      messageCommand = CommandKind.globalUserState;
      break;
    default:
      log('Unknown command: $command');
      messageCommand = CommandKind.none;
  }
  return messageCommand;
}
