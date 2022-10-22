// Dart imports:
import 'dart:convert';

// Project imports:
import 'package:twitch_chat_flutter/constants.dart';
import 'package:twitch_chat_flutter/models/paginated_response.dart';
import 'package:twitch_chat_flutter/models/stream.dart';
import 'package:twitch_chat_flutter/models/user.dart';
import 'package:twitch_chat_flutter/repositories/backend_api.dart';

class TwitchRepository {
  final BackendApi _backendApi;
  final String _streamsUrl = '/helix/streams';

  const TwitchRepository(this._backendApi);

  Future<String> getDefaultToken() async {
    final response = await _backendApi.client.post(
      '/oauth2/token',
      queryParameters: {
        'client_id': clientId,
        'client_secret': secret,
        'grant_type': 'client_credentials',
      },
    );
    return jsonDecode(response.data)['access_token'];
  }

  Future<bool> validateToken({required String token}) async {
    final response = await _backendApi.client.get('/oauth2/validate');
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<PaginatedResponse<StreamTwitch>> getTopStreams({
    String? cursor,
  }) async {
    final response = await _backendApi.client.get(
      _streamsUrl,
      queryParameters: {if (cursor != null) 'after': cursor},
    );
    List<StreamTwitch> items = [];
    response.data["data"].forEach((json) {
      items.add(StreamTwitch.fromJson(json));
    });
    return PaginatedResponse(
      items: items,
      next: response.data["pagination"]['cursor'] ?? "",
    );
  }

  Future<PaginatedResponse<StreamTwitch>> getFollowedStreams({
    required String id,
    String? cursor,
  }) async {
    id = (await getUserInfo()).id;
    final response = await _backendApi.client.get('$_streamsUrl/followed',
        queryParameters: {'user_id': id, if (cursor != null) 'after': cursor});
    List<StreamTwitch> items = [];
    response.data["data"].forEach((json) {
      items.add(StreamTwitch.fromJson(json));
    });
    return PaginatedResponse(
      items: items,
      next: response.data["pagination"]['cursor'] ?? "",
    );
  }

  Future<PaginatedResponse<StreamTwitch>> getStreamsUnderCategory({
    required String gameId,
    String? cursor,
  }) async {
    final response = await _backendApi.client.get(_streamsUrl,
        queryParameters: {
          'game_id': gameId,
          if (cursor != null) 'after': cursor
        });
    List<StreamTwitch> items = [];
    response.data["data"].forEach((json) {
      items.add(StreamTwitch.fromJson(json));
    });
    return PaginatedResponse(
      items: items,
      next: response.data["pagination"] ?? "",
    );
  }

  Future<StreamTwitch> getStream({
    required String userLogin,
  }) async {
    final response =
        await _backendApi.client.get('/helix/streams?user_login=$userLogin');
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.data);
      final data = decoded['data'] as List;

      if (data.isNotEmpty) {
        return StreamTwitch.fromJson(data.first);
      } else {
        return Future.error('$userLogin is offline');
      }
    } else {
      return Future.error('Failed to get stream info');
    }
  }

  Future<UserTwitch> getUser({
    String? userLogin,
    String? id,
  }) async {
    final response =
        await _backendApi.client.get('/helix/users', queryParameters: {
      if (id != null) 'id': id else 'login': userLogin,
    });

    return UserTwitch.fromJson((response.data['data'] as List).first);
  }

  Future<UserTwitch> getUserInfo() async {
    final response = await _backendApi.client.get('/helix/users');
    return UserTwitch.fromJson((response.data['data'] as List).first);
  }
}
