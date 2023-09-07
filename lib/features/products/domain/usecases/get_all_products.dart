import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repository/products_repository.dart';

class GetAllProductsUsecase {
  final ProductsRepository _repository;

  GetAllProductsUsecase({required ProductsRepository repository})
      : _repository = repository;

  Future<Either<Failure, List<Product>>> call() async {
    return await _repository.getAllProducts(false);
  }
}
