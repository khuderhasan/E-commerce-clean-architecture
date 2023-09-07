part of 'orders_bloc.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object> get props => [];
}

class LoadingOrdersState extends OrdersState {}

class LoadedOrdersState extends OrdersState {
  final List<OrderEnity> loadedOrders;

  const LoadedOrdersState({required this.loadedOrders});
}

class SuccessAddOrderState extends OrdersState {
  final String message;

  const SuccessAddOrderState({required this.message});
}

class ErrorOrdersState extends OrdersState {
  final String errorMessage;

  const ErrorOrdersState({required this.errorMessage});
}
