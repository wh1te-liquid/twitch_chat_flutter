// Dart imports:
import 'dart:developer';

Map<String, dynamic>? parseMessage(String message) {
  final Map<String, dynamic> parsedMessage = {
    "tags": null,
    "source": null,
    "command": null,
    "parameters": null
  };

  var idx = 0;

  String? rawTagsComponent;
  String? rawSourceComponent;
  String? rawCommandComponent;
  String? rawParametersComponent;

  if (message[idx] == '@') {
    var endIdx = message.indexOf(' ');
    rawTagsComponent = message.substring(1, endIdx);
    idx = endIdx + 1;
  }

  if (message[idx] == ':') {
    idx += 1;
    var endIdx = message.indexOf(' ', idx);
    rawSourceComponent = message.substring(idx, endIdx);
    idx = endIdx + 1;
  }

  var endIdx = message.indexOf(':', idx);
  if (-1 == endIdx) {
    endIdx = message.length;
  }

  rawCommandComponent = message.substring(idx, endIdx).trim();
  if (endIdx != message.length) {
    idx = endIdx + 1;
    rawParametersComponent = message.substring(idx);
  }

  parsedMessage['command'] = parseCommand(rawCommandComponent);

  if (parsedMessage['command'] == null) {
    return null;
  } else {
    if (null != rawTagsComponent) {
      parsedMessage['tags'] = parseTags(rawTagsComponent);
    }

    parsedMessage['source'] = parseSource(rawSourceComponent);

    parsedMessage['parameters'] = rawParametersComponent;
    if ((rawParametersComponent ?? '').isNotEmpty &&
        rawParametersComponent?[0] == '!') {
      parsedMessage['command'] =
          parseParameters(rawParametersComponent!, parsedMessage['command']);
    }
  }

  return parsedMessage;
}

Map parseTags(String tags) {
  const tagsToIgnore = {'client-nonce': null, 'flags': null};

  var dictParsedTags = {};
  List<String> parsedTags = tags.split(';');

  for (String tag in parsedTags) {
    var parsedTag = tag.split('=');
    String? tagValue = (parsedTag[1] == '') ? null : parsedTag[1];

    switch (parsedTag[0]) {
      case 'badges':
      case 'badge-info':
        if (tagValue != null && tagValue.isNotEmpty) {
          var dict = {};
          var badges = tagValue.split(',');
          for (var pair in badges) {
            var badgeParts = pair.split('/');
            dict[badgeParts[0]] = badgeParts[1];
          }
          dictParsedTags[parsedTag[0]] = dict;
        } else {
          dictParsedTags[parsedTag[0]] = null;
        }
        break;
      case 'emotes':
        if (tagValue != null && tagValue.isNotEmpty) {
          var dictEmotes = {}; // Holds a list of emote objects.
          var emotes = tagValue.split('/');
          for (var emote in emotes) {
            var emoteParts = emote.split(':');

            var textPositions =
                []; // The list of position objects that identify
            // the location of the emote in the chat message.
            var positions = emoteParts[1].split(',');
            for (var position in positions) {
              var positionParts = position.split('-');
              textPositions.add({
                "startPosition": positionParts[0],
                "endPosition": positionParts[1]
              });
            }

            dictEmotes[emoteParts[0]] = textPositions;
          }
          dictParsedTags[parsedTag[0]] = dictEmotes;
        } else {
          dictParsedTags[parsedTag[0]] = null;
        }

        break;
      case 'emote-sets':
        var emoteSetIds = tagValue?.split(',');
        dictParsedTags[parsedTag[0]] = emoteSetIds;
        break;
      default:
        if (!tagsToIgnore.containsKey(parsedTag[0])) {
          dictParsedTags[parsedTag[0]] = tagValue;
        }
    }
  }

  return dictParsedTags;
}

Map? parseCommand(rawCommandComponent) {
  Map? parsedCommand;
  List<String> commandParts = rawCommandComponent.split(' ');
  switch (commandParts[0]) {
    case 'JOIN':
    case 'PART':
    case 'NOTICE':
    case 'CLEARMSG':
    case 'CLEARCHAT':
    case 'HOSTTARGET':
    case 'USERNOTICE':
    case 'PRIVMSG':
      parsedCommand = {'command': commandParts[0], 'channel': commandParts[1]};
      break;
    case 'PING':
      parsedCommand = {'command': commandParts[0]};
      break;
    case 'CAP':
      parsedCommand = {
        'command': commandParts[0],
        'isCapRequestEnabled': (commandParts[2] == 'ACK') ? true : false,
      };
      break;
    case 'GLOBALUSERSTATE':
      parsedCommand = {'command': commandParts[0]};
      break;
    case 'USERSTATE':
    case 'ROOMSTATE':
      parsedCommand = {'command': commandParts[0], 'channel': commandParts[1]};
      break;
    case 'RECONNECT':
      log('The Twitch IRC server is about to terminate the connection for maintenance.');
      parsedCommand = {"command": commandParts[0]};
      break;
    case '421':
      log("Unsupported IRC command: ${commandParts[2]}");
      return null;
    case '001':
      parsedCommand = {'command': commandParts[0], 'channel': commandParts[1]};
      break;
    case '002':
    case '003':
    case '004':
    case '353':
    case '366':
    case '372':
    case '375':
    case '376':
      log('numeric message: ${commandParts[0]}');
      return null;
    default:
      log('\nUnexpected command: ${commandParts[0]}\n');
      return null;
  }

  return parsedCommand;
}

Map? parseSource(rawSourceComponent) {
  if (null == rawSourceComponent) {
    return null;
  } else {
    var sourceParts = rawSourceComponent.split('!');
    return {
      'nick': (sourceParts.length == 2) ? sourceParts[0] : null,
      'host': (sourceParts.length == 2) ? sourceParts[1] : sourceParts[0]
    };
  }
}

Map? parseParameters(String rawParametersComponent, Map command) {
  var idx = 0;
  var commandParts = rawParametersComponent.substring(idx + 1).trim();
  var paramsIdx = commandParts.indexOf(' ');

  if (-1 == paramsIdx) {
    command['botCommand'] = commandParts.substring(0);
  } else {
    command['botCommand'] = commandParts.substring(0, paramsIdx);
    command['botCommandParams'] = commandParts.substring(paramsIdx).trim();
  }

  return command;
}
