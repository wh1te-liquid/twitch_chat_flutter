// Dart imports:
import 'dart:developer';

// Package imports:
import 'package:dio/dio.dart';

// Project imports:
import 'package:twitch_chat_flutter/constants.dart';

Dio getDio({String? base}) {
  final dio = Dio(BaseOptions(baseUrl: base ?? baseUrl));
  dio.interceptors.add(
    InterceptorsWrapper(onResponse: (response, handler) {
      logResponse(response: response);
      return handler.next(response);
    }, onError: (error, handler) async {
      logResponse(error: error);
      return handler.next(error);
    }),
  );
  return dio;
}

void logResponse({Response? response, DioError? error}) {
  final res = response ?? error?.response;
  final RequestOptions options = res?.requestOptions ?? error!.requestOptions;
  final shortUri = res?.realUri ?? options.uri;
  final shortUrl = shortUri.toString().replaceAll(options.baseUrl, "");
  var output = "${options.method} "
      "${res?.statusCode} "
      "$shortUrl";

  final statusCode = res?.statusCode ?? 0;
  if (statusCode >= 400 && statusCode <= 499) {
    output += " ${res?.data}";
  }
  log(output);
}
