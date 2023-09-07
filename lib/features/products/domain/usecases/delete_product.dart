import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repository/products_repository.dart';

class DeleteProductUsecase {
  final ProductsRepository _repository;

  DeleteProductUsecase({required ProductsRepository repository})
      : _repository = repository;

  Future<Either<Failure, Unit>> call({required String productId}) async {
    return await _repository.deleteProduct(productId);
  }
}
