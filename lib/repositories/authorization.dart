import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:twitch_chat_flutter/constants.dart';
import 'package:twitch_chat_flutter/repositories/dio.dart';

class JWT {
  final String accessToken;
  final String refreshToken;

  JWT(
    this.accessToken,
    this.refreshToken,
  );
}

class AuthRepository {
  JWT? _jwt;
  final _storage = const FlutterSecureStorage();

  AuthRepository({JWT? jwt}) : _jwt = jwt;

  JWT? get jwt => _jwt;

  bool get isAuthenticated {
    return _jwt != null;
  }

  Future<void> auth({required String code}) async {
    final backendApi = getDio();
    final response = await backendApi.post("/oauth2/token", queryParameters: {
      'client_id': clientId,
      'client_secret': secret,
      'code': code,
      'grant_type': 'authorization_code',
      'redirect_uri': 'http://localhost',
    });
    _jwt = JWT(response.data['access_token'], response.data['refresh_token']);
    saveTokens(_jwt!.accessToken, _jwt!.refreshToken);
  }

  Future<void> logout() async {
    _jwt = null;
    _storage.delete(key: "accessToken");
    _storage.delete(key: "refreshToken");
  }

  void saveTokens(String accessToken, String refreshToken) {
    _jwt = JWT(accessToken, refreshToken);
    _storage.write(key: "accessToken", value: accessToken);
    _storage.write(key: "refreshToken", value: refreshToken);
  }

  Future<void> loadTokens() async {
    try {
      final accessToken = await _storage.read(key: "accessToken");
      final refreshToken = await _storage.read(key: "refreshToken");
      if (accessToken != null && refreshToken != null) {
        _jwt = JWT(accessToken, refreshToken);
      }
    } on PlatformException catch (_) {
      await _storage.deleteAll();
    }
  }
}
