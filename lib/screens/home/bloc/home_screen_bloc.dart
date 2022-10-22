// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:twitch_chat_flutter/models/stream.dart';
import 'package:twitch_chat_flutter/repositories/twitch.dart';

part 'home_screen_event.dart';

part 'home_screen_state.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  final TwitchRepository _twitchRepository;

  HomeScreenBloc({required TwitchRepository twitchRepository})
      : _twitchRepository = twitchRepository,
        super(HomeScreenInitial()) {
    on<HomeScreenEvent>((event, emit) async {
      await fetch(emit: emit);
    });
  }

  Future<void> fetch({required Emitter<HomeScreenState> emit}) async {
    if (state is HomeScreenInitial) {
      emit(HomeScreenLoading());
      final response = await _twitchRepository.getTopStreams();
      emit(HomeScreenLoaded(items: response.items, nextUrl: response.next));
    }
  }
}
