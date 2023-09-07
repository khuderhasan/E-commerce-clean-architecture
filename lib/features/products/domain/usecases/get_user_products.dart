import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product.dart';
import '../repository/products_repository.dart';

class GetUserProductsUsecase {
  final ProductsRepository repository;

  GetUserProductsUsecase({required this.repository});

  Future<Either<Failure, List<Product>>> call() async {
    return await repository.getAllProducts(true);
  }
}
