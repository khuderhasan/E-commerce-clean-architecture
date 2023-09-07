part of 'orders_bloc.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object> get props => [];
}

class GetOrdersEvent extends OrdersEvent {}

class AddOrderEvent extends OrdersEvent {
  final List<CartItem> cartProducts;
  final double finalPrice;

  const AddOrderEvent({required this.cartProducts, required this.finalPrice});
}
