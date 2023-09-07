import 'package:equatable/equatable.dart';

import '../../data/models/cart_item_model.dart';

class OrderEnity extends Equatable {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  const OrderEnity({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });

  @override
  List<Object?> get props => [id, amount, products, dateTime];
}
