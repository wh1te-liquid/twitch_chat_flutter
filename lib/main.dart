// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:twitch_chat_flutter/repositories/authorization.dart';
import 'package:twitch_chat_flutter/repositories/backend_api.dart';
import 'package:twitch_chat_flutter/repositories/dio.dart';
import 'package:twitch_chat_flutter/repositories/twitch.dart';
import 'package:twitch_chat_flutter/repositories/twitch_irc_client.dart';
import 'package:twitch_chat_flutter/screens/authorization/authorization_screen.dart';
import 'package:twitch_chat_flutter/screens/authorization/bloc/authorization_bloc.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: RepositoryProvider(
        create: (context) => BackendApi(
          authRepository: context.read<AuthRepository>(),
          dio: getDio(),
        ),
        child: MultiRepositoryProvider(
          providers: [
            RepositoryProvider(
              create: (context) => TwitchIrcClient(),
            ),
            RepositoryProvider(
              create: (context) => TwitchRepository(context.read<BackendApi>()),
            ),
          ],
          child: BlocProvider(
            create: (context) =>
                AuthorizationBloc(context.read<AuthRepository>())
                  ..add(AuthorizationCheckState()),
            child: MaterialApp(
              title: 'TwitchChat',
              theme: ThemeData(
                brightness: Brightness.dark,
                appBarTheme: const AppBarTheme(
                  color: Color(0xff9146ff),
                  elevation: 0.0,
                ),
                colorScheme: ColorScheme.fromSwatch(
                  brightness: Brightness.dark,
                  primarySwatch: Colors.deepPurple,
                  accentColor: const Color(0xff9146ff),
                ),
                toggleableActiveColor: const Color(0xff9146ff),
              ),
              onGenerateRoute: (_) => AuthorizationScreen.route(),
            ),
          ),
        ),
      ),
    );
  }
}
