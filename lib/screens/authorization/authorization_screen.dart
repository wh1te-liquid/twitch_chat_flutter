import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitch_chat_flutter/constants.dart';
import 'package:twitch_chat_flutter/screens/authorization/bloc/authorization_bloc.dart';
import 'package:twitch_chat_flutter/screens/authorization/widgets/twitch_auth_webview.dart';

class AuthorizationScreen extends StatelessWidget {
  const AuthorizationScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (context) => const AuthorizationScreen());
  }

  String get loginUrl => "$baseUrl/oauth2/authorize"
      "?response_type=code"
      "&client_id=$clientId"
      "&redirect_uri=http://localhost"
      "&scope=chat%3Aread+chat%3Aedit";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthorizationBloc, AuthorizationState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () async {
                    Navigator.push(
                            context, TwitchAuthWebViewScreen.route(loginUrl))
                        .then((code) {
                      if (code != null) {
                        context
                            .read<AuthorizationBloc>()
                            .add(AuthorizationInit(code: code));
                      }
                    });
                  },
                  child: Container(height: 50, width: 80, color: Colors.purple))
            ],
          ),
        );
      },
    );
  }
}
