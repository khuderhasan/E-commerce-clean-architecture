part of 'get_products_bloc.dart';

abstract class GetProductsEvent extends Equatable {
  const GetProductsEvent();

  @override
  List<Object> get props => [];
}

class GetAllProductsEvent extends GetProductsEvent {}

class GetFavouriteProductsEvent extends GetProductsEvent {}

class GetUserProductsEvent extends GetProductsEvent {}
