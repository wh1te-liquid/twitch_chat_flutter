import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitch_chat_flutter/screens/authorization/bloc/authorization_bloc.dart';

class AuthorizationScreen extends StatelessWidget {
  const AuthorizationScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (context) => const AuthorizationScreen());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthorizationBloc, AuthorizationState>(
      builder: (context, state) {
        print(1);
        return Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () => context
                      .read<AuthorizationBloc>().init(),
                  child: Container(
                    height: 100,
                    width: 100,
                    color: Colors.black,
                  )),
            ],
          ),
        );
      },
    );
  }
}
