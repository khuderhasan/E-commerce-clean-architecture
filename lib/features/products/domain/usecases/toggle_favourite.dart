import 'package:dartz/dartz.dart';
import 'package:shop_app_clean_architecture/core/error/failures.dart';
import 'package:shop_app_clean_architecture/features/products/domain/repository/products_repository.dart';

class ToggleFavouriteUsecase {
  final ProductsRepository _repository;

  ToggleFavouriteUsecase({
    required ProductsRepository repository,
  }) : _repository = repository;
  Future<Either<Failure, Unit>> call(
      bool currentFavouriteState, String productId) async {
    return _repository.toggleFavourite(currentFavouriteState, productId);
  }
}
