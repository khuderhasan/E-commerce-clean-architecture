import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repository/products_repository.dart';

class AddProductUsecase {
  final ProductsRepository _repository;

  AddProductUsecase({required ProductsRepository repository})
      : _repository = repository;
  Future<Either<Failure, Unit>> call({required Product newProduct}) async {
    return await _repository.addProdcut(newProduct);
  }
}
