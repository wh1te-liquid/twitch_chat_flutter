// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// Project imports:
import 'package:twitch_chat_flutter/repositories/authorization.dart';

part 'authorization_event.dart';

part 'authorization_state.dart';

class AuthorizationBloc extends Bloc<AuthorizationEvent, AuthorizationState> {
  final AuthRepository _authRepository;

  AuthorizationBloc(this._authRepository)
      : super(const AuthorizationState(
          status: AuthStatus.initial,
          authCode: '',
        )) {
    on<AuthorizationLogin>((event, emit) async {
      await auth(code: event.code, emit: emit);
    });
    on<AuthorizationCheckState>((event, emit) async {
      await checkAuthState(emit: emit);
    });
  }

  Future<void> checkAuthState({
    required Emitter<AuthorizationState> emit,
  }) async {
    await _authRepository.loadTokens();
    if (_authRepository.isAuthenticated) {
      emit(state.copyWith(status: AuthStatus.success));
    } else {
      emit(state.copyWith(status: AuthStatus.initial));
    }
  }

  Future<void> auth({
    required String code,
    required Emitter<AuthorizationState> emit,
  }) async {
    if (state.status == AuthStatus.initial) {
      emit(state.copyWith(status: AuthStatus.loading));
      try {
        await _authRepository.auth(code: code);
        emit(state.copyWith(status: AuthStatus.success));
      } catch (_) {
        emit(state.copyWith(status: AuthStatus.error));
      }
    }
  }
}
