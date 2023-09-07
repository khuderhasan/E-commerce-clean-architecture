import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/get_all_products.dart';
import '../../../domain/usecases/get_user_products.dart';

part 'get_products_event.dart';
part 'get_products_state.dart';

class GetProductsBloc extends Bloc<GetProductsEvent, GetProductsState> {
  final GetAllProductsUsecase getAllProducts;
  final GetUserProductsUsecase getUserProducts;
  GetProductsBloc({
    required this.getAllProducts,
    required this.getUserProducts,
  }) : super(GetProductsLoadingState()) {
    on<GetProductsEvent>((event, emit) async {
      if (event is GetAllProductsEvent) {
        emit(GetProductsLoadingState());
        final allProductsOrFailure = await getAllProducts();
        emit(_mapProductsListOrFailuerToState(allProductsOrFailure, false));
      } else if (event is GetUserProductsEvent) {
        emit(GetProductsLoadingState());
        final userProductsOrFailure = await getUserProducts();
        emit(_mapProductsListOrFailuerToState(userProductsOrFailure, false));
      } else if (event is GetFavouriteProductsEvent) {
        emit(GetProductsLoadingState());
        final favouriteProdcutsOrFailure = await getAllProducts();
        emit(
            _mapProductsListOrFailuerToState(favouriteProdcutsOrFailure, true));
      }
    });
  }
}

GetProductsState _mapProductsListOrFailuerToState(
    Either<Failure, List<Product>> either, bool onlyFavourites) {
  return either.fold((failure) {
    if (failure.runtimeType == OfflineFailure) {
      return const GetProductsErrorState("Sorry , You are Offline");
    }
    return const GetProductsErrorState("Sorry , Could not Get Products");
  },
      (products) => (onlyFavourites)
          ? GetProductsLoadedState(
              products.where((product) => product.isFavourite == true).toList())
          : GetProductsLoadedState(products));
}
