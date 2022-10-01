part of 'authorization_bloc.dart';

enum AuthStatus {
  initial,
  loading,
  success,
  error,
}

@immutable
class AuthorizationState {
  final AuthStatus _status;
  final String _authCode;

  const AuthorizationState({
    required AuthStatus status,
    required String authCode,
  })  : _status = status,
        _authCode = authCode;

  AuthStatus get status => _status;

  String get authCode => _authCode;

  AuthorizationState copyWith({
    AuthStatus? status,
    String? authCode,
  }) {
    return AuthorizationState(
      status: status ?? _status,
      authCode: authCode ?? _authCode,
    );
  }
}
