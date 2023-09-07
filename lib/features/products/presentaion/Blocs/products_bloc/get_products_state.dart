part of 'get_products_bloc.dart';

abstract class GetProductsState extends Equatable {
  const GetProductsState();

  @override
  List<Object> get props => [];
}

class GetProductsLoadingState extends GetProductsState {}

class GetProductsLoadedState extends GetProductsState {
  final List<Product> productsList;

  const GetProductsLoadedState(this.productsList);
}

class GetProductsErrorState extends GetProductsState {
  final String errorMessage;

  const GetProductsErrorState(this.errorMessage);
}
