import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class SignUpUsecase {
  final AuthRepository _repository;

  SignUpUsecase({required AuthRepository repository})
      : _repository = repository;

  Future<Either<Failure, User>> call(String email, String password) async {
    return await _repository.signUp(email, password);
  }
}
