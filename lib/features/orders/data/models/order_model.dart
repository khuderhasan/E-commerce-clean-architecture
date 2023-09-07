import '../../domain/entities/order_entitiy.dart';
import 'cart_item_model.dart';

class OrderModel extends OrderEnity {
  const OrderModel(
      {required super.id,
      required super.amount,
      required super.products,
      required super.dateTime});

  factory OrderModel.fromJson(Map<String, dynamic> json, String orderId) {
    return OrderModel(
        id: orderId,
        amount: json["amount"],
        products: (json["products"] as List<dynamic>)
            .map((item) => CartItem.fromJson(item))
            .toList(),
        dateTime: json["dateTime"]);
  }

  Map<String, dynamic> toJson() {
    return {
      "amount": amount,
      "products": products.map((product) => {
            "id": product.id,
            "title": product.title,
            "price": product.price,
            "quantitiy": product.quantity
          }),
      "dateTime": dateTime
    };
  }
}
