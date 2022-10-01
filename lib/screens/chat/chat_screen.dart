import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitch_chat_flutter/repositories/twitch_irc_client.dart';
import 'package:twitch_chat_flutter/screens/chat/bloc/chat_bloc.dart';
import 'package:twitch_chat_flutter/screens/chat/widgets/message_card.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static Route route({required TwitchIrcClient client}) {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => ChatBloc(client: client),
        child: const ChatScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff18181a),
      body: BlocBuilder<ChatBloc, ChatState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                verticalDirection: VerticalDirection.up,
                children: List.generate(
                    state.messages.length,
                    (index) => MessageCard(
                          message: state.messages[index],
                        )),
              ),
            ),
          );
        },
      ),
    );
  }
}
