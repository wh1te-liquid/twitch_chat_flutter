// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import 'package:twitch_chat_flutter/repositories/authorization.dart';
import '../constants.dart';

// Project imports:

class BackendApi {
  final AuthRepository _authRepository;
  final Dio _client;

  Dio get client => _client;

  BackendApi({
    required AuthRepository authRepository,
    required Dio dio,
  })  : _authRepository = authRepository,
        _client = dio {
    _client.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      options.headers["Authorization"] =
          "Bearer ${_authRepository.jwt!.accessToken}";
      options.headers['Client-Id'] = clientId;
      return handler.next(options);
    }));
  }
}
