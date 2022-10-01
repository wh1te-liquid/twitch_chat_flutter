import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitch_chat_flutter/repositories/authorization.dart';
import 'package:twitch_chat_flutter/repositories/twitch_irc_client.dart';
import 'package:twitch_chat_flutter/screens/authorization/authorization_screen.dart';

// Package imports:
import 'package:twitch_chat_flutter/screens/authorization/bloc/authorization_bloc.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider(
          create: (context) => TwitchIrcClient(),
        ),
      ],
      child: BlocProvider(
        create: (context) => AuthorizationBloc(context.read<AuthRepository>())
          ..add(AuthorizationCheckState()),
        child: MaterialApp(
          title: 'TwitchChat',
          onGenerateRoute: (_) => AuthorizationScreen.route(),
        ),
      ),
    );
  }
}
