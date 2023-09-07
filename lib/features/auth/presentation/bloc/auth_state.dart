part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class InitialAuthState extends AuthState {}

class LoadinAuthgState extends AuthState {}

class SuccessAuthState extends AuthState {
  final User user;
  const SuccessAuthState({required this.user});
}

class ErrorAuthState extends AuthState {
  final String errorMessage;
  const ErrorAuthState({required this.errorMessage});
}
