class CartItem {
  String id;

  String title;

  double price;

  int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.price,
    required this.quantity,
  });
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
        id: json["id"],
        title: json["title"],
        price: json["price"],
        quantity: json["quantity"]);
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "price": price,
      "quantity": quantity,
    };
  }
}
