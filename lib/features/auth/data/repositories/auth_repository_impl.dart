import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl({required this.remoteDatasource});
  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final user = await remoteDatasource.login(email, password);
      return Right(user);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }

  @override
  Future<Either<Failure, User>> signUp(String email, String password) async {
    try {
      final user = await remoteDatasource.signUp(email, password);
      return Right(user);
    } on ServerException catch (exception) {
      return Left(ServerFailure(message: exception.message));
    }
  }
}
