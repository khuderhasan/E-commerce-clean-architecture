import 'package:dartz/dartz.dart';
import '../../../../core/network/network_info.dart';
import '../models/produt_model.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/product.dart';
import '../../domain/repository/products_repository.dart';
import '../datasourse/product_remote_datasource.dart';

class ProductsRepositoryImpl extends ProductsRepository {
  final ProductsRemoteDatasourceImpl remoteDatasource;
  final NetworkInfoImpl networkInfoImpl;

  ProductsRepositoryImpl({
    required this.remoteDatasource,
    required this.networkInfoImpl,
  });
  @override
  Future<Either<Failure, List<Product>>> getAllProducts(
      [bool filterByUser = false]) async {
    if (await networkInfoImpl.isConnected) {
      try {
        final productsList =
            await remoteDatasource.getAllProducts(filterByUser);
        return Right(productsList);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addProdcut(Product newProduct) async {
    if (await networkInfoImpl.isConnected) {
      final productModel = ProductModel(
          title: newProduct.title,
          description: newProduct.description,
          price: newProduct.price,
          imageUrl: newProduct.imageUrl,
          isFavourite: newProduct.isFavourite);
      try {
        await remoteDatasource.addProduct(productModel);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteProduct(String productId) async {
    if (await networkInfoImpl.isConnected) {
      try {
        await remoteDatasource.deleteProduct(productId);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateProduct(
      Product updatedProduct, String productId) async {
    if (await networkInfoImpl.isConnected) {
      final updatedProductModel = ProductModel(
          title: updatedProduct.title,
          description: updatedProduct.description,
          price: updatedProduct.price,
          imageUrl: updatedProduct.imageUrl,
          isFavourite: updatedProduct.isFavourite);

      try {
        await remoteDatasource.updateProduct(updatedProductModel, productId);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> toggleFavourite(
      bool currentFavouriteState, String productId) async {
    if (await networkInfoImpl.isConnected) {
      try {
        await remoteDatasource.toggleFavourite(
            currentFavouriteState, productId);
        return const Right(unit);
      } catch (error) {
        throw ServerFailure();
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
