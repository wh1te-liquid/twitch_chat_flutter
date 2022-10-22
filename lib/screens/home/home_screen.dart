// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:twitch_chat_flutter/repositories/twitch.dart';
import 'package:twitch_chat_flutter/screens/home/bloc/home_screen_bloc.dart';
import 'package:twitch_chat_flutter/screens/home/widgets/stream_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static MaterialPageRoute route() {
    return MaterialPageRoute(builder: (context) {
      return BlocProvider(
        create: (context) => HomeScreenBloc(
          twitchRepository: context.read<TwitchRepository>(),
        ),
        child: const HomeScreen(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenBloc, HomeScreenState>(
      builder: (context, state) {
        if (state is HomeScreenInitial) {
          context.read<HomeScreenBloc>().add(HomeScreenInit());
        }
        if (state is HomeScreenLoaded) {
          return Scaffold(
            backgroundColor: const Color(0xff0e0e0f),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: List.generate(
                      state.items.length,
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: StreamCard(
                          streamInfo: state.items[index],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
