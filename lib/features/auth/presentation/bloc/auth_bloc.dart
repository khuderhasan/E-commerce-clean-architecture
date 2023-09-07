import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/signup_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase login;
  final SignUpUsecase signUp;
  AuthBloc({required this.login, required this.signUp})
      : super(InitialAuthState()) {
    on<AuthEvent>((event, emit) async {
      if (event is LoginEvent) {
        emit(LoadinAuthgState());
        final userOrFailure = await login(event.email, event.password);
        emit(_mapSuccessOrFailiuerToState(userOrFailure));
      } else if (event is SignUpEvent) {
        emit(LoadinAuthgState());
        final userOrFailuer = await signUp(event.email, event.password);
        emit(_mapSuccessOrFailiuerToState(userOrFailuer));
      }
    });
  }
  AuthState _mapSuccessOrFailiuerToState(Either<Failure, User> either) {
    return either.fold(
      (failure) =>
          ErrorAuthState(errorMessage: _mapFailureToErrorMessage(failure)),
      (user) => SuccessAuthState(user: user),
    );
  }
}

String _mapFailureToErrorMessage(Failure failure) {
  switch (failure.runtimeType) {
    case ServerFailure:
      ServerFailure serverFailure = failure as ServerFailure;
      return _serverFailureMessageToErrorMessage(serverFailure.message!);
    default:
      return "Unexpected Error ,Please try again later ";
  }
}

String _serverFailureMessageToErrorMessage(String message) {
  if (message.contains("EMAIL_EXISTS")) {
    return "This Email Address is already in use";
  } else if (message.contains("INVALID_EMAIL")) {
    return "This is not a valid Email Address";
  } else if (message.contains("WEAK_PASSWORD")) {
    return "This is password is weak";
  } else if (message.contains("EMAIL_NOT_FOUND")) {
    return "Could not find a user with this email";
  } else if (message.contains("INVALID_PASSWORD")) {
    return "Invalid Password";
  }
  return "Authentication Error";
}
