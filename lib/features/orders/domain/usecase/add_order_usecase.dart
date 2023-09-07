import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../data/models/cart_item_model.dart';
import '../repositories/orders_repository.dart';

class AddOrderUsecase {
  final OrdersRepository _repository;

  AddOrderUsecase({required OrdersRepository repository})
      : _repository = repository;
  Future<Either<Failure, Unit>> call(
      List<CartItem> cartProducts, double finalPrice) async {
    return await _repository.addOrder(cartProducts, finalPrice);
  }
}
