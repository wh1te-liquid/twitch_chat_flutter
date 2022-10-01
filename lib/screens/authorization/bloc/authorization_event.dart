part of 'authorization_bloc.dart';

@immutable
abstract class AuthorizationEvent {}

class AuthorizationLogin extends AuthorizationEvent {
  final String code;

  AuthorizationLogin({required this.code});
}

class AuthorizationCheckState extends AuthorizationEvent {}
