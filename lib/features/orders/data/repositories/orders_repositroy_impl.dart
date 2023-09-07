import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/order_entitiy.dart';
import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_datasource.dart';
import '../models/cart_item_model.dart';

class OrdersRepositoryImpl extends OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;
  final NetworkInfoImpl networkInfo;

  OrdersRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, Unit>> addOrder(
      List<CartItem> cartProducts, double finalPrice) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteDataSource.addOrder(cartProducts, finalPrice);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<OrderEnity>>> getOrders() async {
    if (await networkInfo.isConnected) {
      try {
        final ordersList = await remoteDataSource.getorders();
        return Right(ordersList);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
