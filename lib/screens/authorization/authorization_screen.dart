// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:twitch_chat_flutter/screens/authorization/bloc/authorization_bloc.dart';
import 'package:twitch_chat_flutter/screens/authorization/widgets/auth_button.dart';
import 'package:twitch_chat_flutter/screens/home/home_screen.dart';

class AuthorizationScreen extends StatelessWidget {
  const AuthorizationScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (context) => const AuthorizationScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthorizationBloc, AuthorizationState>(
      listener: (context, state) {
        if (state.status == AuthStatus.success) {
          // final client = context.read<TwitchIrcClient>();
          // client.connectToIRC(
          //     accessToken: context.read<AuthRepository>().jwt!.accessToken,
          //     channel: 'bratishkinoff');
          Navigator.pushReplacement(context, HomeScreen.route());
          // Navigator.push(context, ChatScreen.route(client: client));
        }
      },
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [AuthButton()],
          ),
        );
      },
    );
  }
}
