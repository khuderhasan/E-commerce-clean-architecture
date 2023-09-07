import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:shop_app_clean_architecture/core/error/exceptions.dart';
import 'package:shop_app_clean_architecture/core/strings/urls.dart';
import 'package:shop_app_clean_architecture/providers/current_user.dart';

import '../../../../core/services/service_locator.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import 'package:http/http.dart' as http;

abstract class OrdersRemoteDataSource {
  Future<List<OrderModel>> getorders();
  Future<Unit> addOrder(List<CartItem> cartProducts, double finalPrice);
}

final authToken = sl<CurrentUser>().authToken;
final userId = sl<CurrentUser>().userId;

class OrdersRemoteDataSourceImpl extends OrdersRemoteDataSource {
  final http.Client _client;

  OrdersRemoteDataSourceImpl({required http.Client client}) : _client = client;

  @override
  Future<Unit> addOrder(List<CartItem> cartProducts, double finalPrice) {
    final addOrderEndPoint =
        Uri.parse("${URLs.OrdersUrl}$userId.json?auth=$authToken");
    var timeStamp = DateTime.now();
    final body = json.encode({
      "amount": finalPrice,
      "dateTime": timeStamp.toIso8601String(),
      "products": cartProducts
          .map((cp) => {
                "id": cp.id,
                "title": cp.title,
                "price": cp.price,
                "quantity": cp.quantity,
              })
          .toList(),
    });

    try {
      _client.post(addOrderEndPoint, body: body);
      return Future.value(unit);
    } catch (error) {
      throw ServerException();
    }
  }

  @override
  Future<List<OrderModel>> getorders() async {
    final getOrdersEndPoint =
        Uri.parse("${URLs.OrdersUrl}$userId.json?auth=$authToken");
    List<OrderModel> orders;
    try {
      final response = await _client.get(getOrdersEndPoint);
      final listOfOrdersMap = jsonDecode(response.body);
      if (listOfOrdersMap == null) {
        orders = [];
      } else {
        orders = _mapOrdersMapToList(listOfOrdersMap);
      }
      return orders;
    } catch (error) {
      throw ServerException();
    }
  }

  List<OrderModel> _mapOrdersMapToList(Map<String, dynamic> listOfOrdersMap) {
    List<OrderModel> loadedOrders = [];
    listOfOrdersMap.forEach((orderId, orderData) {
      loadedOrders.add(OrderModel(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity']))
              .toList()));
    });
    return loadedOrders;
  }
}
