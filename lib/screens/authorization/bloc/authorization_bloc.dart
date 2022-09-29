import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:twitch_chat_flutter/repositories/authorization.dart';

part 'authorization_event.dart';

part 'authorization_state.dart';

class AuthorizationBloc extends Bloc<AuthorizationEvent, AuthorizationState> {
  final AuthRepository authRepository;

  AuthorizationBloc(this.authRepository) : super(AuthorizationInitial()) {
    on<AuthorizationEvent>((event, emit) {});
  }

  void init() {}
}
