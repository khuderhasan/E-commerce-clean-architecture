import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order_entitiy.dart';
import '../repositories/orders_repository.dart';

class GetOrdersUsecase {
  final OrdersRepository _repository;

  GetOrdersUsecase({required OrdersRepository repository})
      : _repository = repository;

  Future<Either<Failure, List<OrderEnity>>> call() async {
    return await _repository.getOrders();
  }
}
