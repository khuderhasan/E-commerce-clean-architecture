import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../providers/cart_provider.dart';
import '../../domain/entities/product.dart';
import 'add_product_item_snack_bar.dart';

class ProductItemWidget extends StatelessWidget {
  final Product product;
  const ProductItemWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            ),
            leading: IconButton(
              color: Colors.deepOrange,
              icon: const Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                cart.addItem(product.id!, product.title, product.price);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  addProductItemSnackBar(
                    (() => cart.removeSingleItem(product.id!)),
                  ),
                );
              },
            ),
            trailing: IconButton(
              color: Colors.deepOrange,
              icon: Icon(
                product.isFavourite! ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () {},
            ),
          ),
          child: GestureDetector(
            onTap: () {},
            child: Image(
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ));
  }
}
