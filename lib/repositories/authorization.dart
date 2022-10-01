import 'package:twitch_chat_flutter/constants.dart';
import 'package:twitch_chat_flutter/repositories/dio.dart';

class JWT {
  final String accessToken;
  final String refreshToken;

  JWT({
    required this.accessToken,
    required this.refreshToken,
  });
}

class AuthRepository {
  JWT? _jwt;

  AuthRepository({JWT? jwt}) : _jwt = jwt;

  JWT? get jwt => _jwt;

  Future<void> auth({required String code}) async {
    final backendApi = getDio();
    final response = await backendApi.post("/oauth2/token", queryParameters: {
      'client_id': clientId,
      'client_secret': secret,
      'code': code,
      'grant_type': 'authorization_code',
      'redirect_uri': 'http://localhost',
    });
    _jwt = JWT(
        accessToken: response.data['access_token'],
        refreshToken: response.data['refresh_token']);
  }
}
