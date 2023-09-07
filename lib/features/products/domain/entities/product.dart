import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final bool? isFavourite;

  const Product({
    this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavourite,
  });
  @override
  List<Object?> get props =>
      [id, title, description, price, imageUrl, isFavourite];
}
