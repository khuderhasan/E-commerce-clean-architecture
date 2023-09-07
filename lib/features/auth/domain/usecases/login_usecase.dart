import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository _repository;

  LoginUsecase({required AuthRepository repository}) : _repository = repository;

  Future<Either<Failure, User>> call(String email, String password) async {
    return await _repository.login(email, password);
  }
}
