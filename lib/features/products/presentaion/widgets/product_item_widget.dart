import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../providers/cart_provider.dart';
import '../../domain/entities/product.dart';
import '../BLoCs/bloc/toggle_favourite_bloc.dart';
import '../Blocs/products_bloc/get_products_bloc.dart';
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
          trailing: BlocBuilder<ToggleFavouriteBloc, ToggleFavouriteState>(
            bloc: context.read<ToggleFavouriteBloc>(),
            builder: (context, state) {
              return IconButton(
                color: Colors.deepOrange,
                icon: Icon(
                  product.isFavourite! ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () {
                  context.read<ToggleFavouriteBloc>().add(
                        FavouriteEvent(
                            currentFavouriteState: product.isFavourite!,
                            productId: product.id!),
                      );
                  context.read<GetProductsBloc>().add(GetAllProductsEvent());
                },
              );
            },
          ),
        ),
        child: GestureDetector(
          onTap: () {},
          child: Image(
            image: NetworkImage(product.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
