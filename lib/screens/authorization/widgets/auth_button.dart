// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:twitch_chat_flutter/constants.dart';
import 'package:twitch_chat_flutter/screens/authorization/bloc/authorization_bloc.dart';
import 'package:twitch_chat_flutter/screens/authorization/widgets/twitch_auth_webview.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({Key? key}) : super(key: key);

  String get loginUrl => "https://id.twitch.tv/oauth2/authorize"
      "?response_type=code"
      "&client_id=$clientId"
      "&redirect_uri=http://localhost"
      "&scope="
      "chat:read chat:edit user:read:follows user:read:blocked_users user:manage:blocked_users";

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, TwitchAuthWebViewScreen.route(loginUrl))
            .then((code) {
          if (code != null) {
            context
                .read<AuthorizationBloc>()
                .add(AuthorizationLogin(code: code));
          }
        });
      },
      child: Container(
        height: 50,
        width: 80,
        decoration: BoxDecoration(
            color: Colors.purple, borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
