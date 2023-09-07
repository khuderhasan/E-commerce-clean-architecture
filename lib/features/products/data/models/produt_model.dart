import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    super.id,
    required super.title,
    required super.description,
    required super.price,
    required super.imageUrl,
    required super.isFavourite,
  });

  factory ProductModel.fromJson(
      String productId, Map<String, dynamic> json, bool? isFavourite) {
    return ProductModel(
      id: productId,
      title: json['title'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      isFavourite: isFavourite,
    );
  }
}
