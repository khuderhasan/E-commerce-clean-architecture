import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/models/cart_item_model.dart';
import '../entities/order_entitiy.dart';

abstract class OrdersRepository {
  Future<Either<Failure, List<OrderEnity>>> getOrders();

  Future<Either<Failure, Unit>> addOrder(
      List<CartItem> cartProducts, double finalPrice);
}
