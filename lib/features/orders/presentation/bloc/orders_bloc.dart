import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shop_app_clean_architecture/features/orders/data/models/cart_item_model.dart';
import 'package:shop_app_clean_architecture/features/orders/data/models/order_model.dart';
import 'package:shop_app_clean_architecture/features/orders/domain/usecase/add_order_usecase.dart';
import 'package:shop_app_clean_architecture/features/orders/domain/usecase/get_orders_usecase.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/order_entitiy.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final AddOrderUsecase addOrder;
  final GetOrdersUsecase getOrders;

  OrdersBloc({
    required this.addOrder,
    required this.getOrders,
  }) : super(LoadingOrdersState()) {
    on<OrdersEvent>((event, emit) async {
      if (event is GetOrdersEvent) {
        emit(LoadingOrdersState());
        final ordersListOrFailure = await getOrders();
        emit(_mapSuccessOrFailureToState(ordersListOrFailure));
      }
      if (event is AddOrderEvent) {
        emit(LoadingOrdersState());
        final successOrFailure =
            await addOrder(event.cartProducts, event.finalPrice);
        emit(_mapSuccessOrFailureToState(successOrFailure));
      }
    });
  }

  OrdersState _mapSuccessOrFailureToState(Either<Failure, dynamic> either) {
    return either.fold((failure) {
      if (failure.runtimeType == OfflineFailure) {
        return const ErrorOrdersState(errorMessage: "Sorry you are offline");
      } else {
        return const ErrorOrdersState(
            errorMessage: "Something went Wrong with the server");
      }
    }, (success) {
      if (success.runtimeType == List<OrderModel>) {
        return LoadedOrdersState(loadedOrders: success);
      }
      return const SuccessAddOrderState(message: "Order added successfully");
    });
  }
}
