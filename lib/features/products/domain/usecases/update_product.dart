import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repository/products_repository.dart';

class UpdateProductUsecase {
  final ProductsRepository _repository;

  UpdateProductUsecase({
    required ProductsRepository repository,
  }) : _repository = repository;

  Future<Either<Failure, Unit>> call(
      {required Product updatedProduct, required String productId}) async {
    return await _repository.updateProduct(updatedProduct, productId);
  }
}
