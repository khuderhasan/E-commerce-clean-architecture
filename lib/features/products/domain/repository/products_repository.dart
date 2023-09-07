import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product.dart';

abstract class ProductsRepository {
  Future<Either<Failure, List<Product>>> getAllProducts(
      [bool filterByUser = false]);

  Future<Either<Failure, Unit>> addProdcut(Product newProduct);

  Future<Either<Failure, Unit>> deleteProduct(String productId);

  Future<Either<Failure, Unit>> updateProduct(
      Product updatedProduct, String productId);
}
