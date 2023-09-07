part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthEvent {
  final String email;
  final String password;

  const LoginEvent({required this.email, required this.password});
}

class SignUpEvent extends AuthEvent {
  final String email;
  final String password;

  const SignUpEvent({required this.email, required this.password});
}
