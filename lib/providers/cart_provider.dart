import 'package:flutter/cupertino.dart';

import '../features/orders/data/models/cart_item_model.dart';

class Cart with ChangeNotifier {
  late Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  double get getTotal {
    var total = 0.0;
    _items.forEach((key, cart) {
      total += cart.price * cart.quantity;
    });
    return total;
  }

  int get itemCount {
    return _items.length;
  }

  void addItem(
    String productId,
    String title,
    double price,
  ) {
    if (_items.containsKey(productId)) {
      // update the quantity of the item
      _items.update(
          productId,
          (existingItem) => CartItem(
                id: existingItem.id,
                title: existingItem.title,
                price: existingItem.price,
                quantity: existingItem.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: productId,
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) return;
    if ((_items[productId]?.quantity ?? 0) > 1) {
      _items.update(
        productId,
        (existingCart) => CartItem(
            id: existingCart.id,
            title: existingCart.title,
            price: existingCart.price,
            quantity: existingCart.quantity - 1),
      );
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }
}
