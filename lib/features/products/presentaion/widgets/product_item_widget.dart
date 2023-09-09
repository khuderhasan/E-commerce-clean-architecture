import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../core/shared_widgets/app_sanck_bar.dart';
import '../../../../core/shared_widgets/error_dialog.dart';

import '../../../../providers/cart_provider.dart';
import '../../domain/entities/product.dart';
import '../BLoCs/bloc/toggle_favourite_bloc.dart';
import 'add_product_item_snack_bar.dart';

class ProductItemWidget extends StatefulWidget {
  final Product product;
  const ProductItemWidget({super.key, required this.product});

  @override
  State<ProductItemWidget> createState() => _ProductItemWidgetState();
}

class _ProductItemWidgetState extends State<ProductItemWidget> {
  bool isFavourite = false;

  @override
  void initState() {
    super.initState();
    isFavourite = widget.product.isFavourite!;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            widget.product.title,
            textAlign: TextAlign.center,
          ),
          leading: IconButton(
            color: Colors.deepOrange,
            icon: const Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItem(widget.product.id!, widget.product.title,
                  widget.product.price);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                addProductItemSnackBar(
                  (() => cart.removeSingleItem(widget.product.id!)),
                ),
              );
            },
          ),
          trailing: BlocConsumer<ToggleFavouriteBloc, ToggleFavouriteState>(
            bloc: context.read<ToggleFavouriteBloc>(),
            // listenWhen: (previous, current) => current != previous,
            listener: (context, state) {
              if (state is ToggleFavouriteSuccess) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar((isFavourite)
                    ? appSnackBar(text: "Product wass Added to Favourites")
                    : appSnackBar(text: "Prduct was Removed from Favourites"));
              } else if (state is ToggleFavouriteFailure) {
                showErrorDialog(context, state.errorMessage);
                setState(() {
                  isFavourite = !isFavourite;
                });
              }
            },
            builder: (context, state) {
              return IconButton(
                color: Colors.deepOrange,
                icon: Icon(
                  isFavourite ? Icons.favorite : Icons.favorite_border,
                ),
                onPressed: () {
                  context.read<ToggleFavouriteBloc>().add(
                        FavouriteEvent(
                            currentFavouriteState: isFavourite,
                            productId: widget.product.id!),
                      );
                  setState(() {
                    isFavourite = !isFavourite;
                  });

                  // context.read<GetProductsBloc>().add(GetAllProductsEvent());
                },
              );
            },
          ),
        ),
        child: GestureDetector(
          onTap: () {},
          child: Image(
            image: NetworkImage(widget.product.imageUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
