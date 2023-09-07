import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Blocs/products_bloc/get_products_bloc.dart';

enum FilteringOption { favourites, all }

Widget popUpMenueButtonWidget(BuildContext context) {
  return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      onSelected: (FilteringOption selectedValue) {
        if (selectedValue == FilteringOption.favourites) {
          context.read<GetProductsBloc>().add(GetFavouriteProductsEvent());
        } else {
          context.read<GetProductsBloc>().add(GetAllProductsEvent());
        }
      },
      itemBuilder: (_) => [
            const PopupMenuItem(
              value: FilteringOption.favourites,
              child: Text('Favourites only'),
            ),
            const PopupMenuItem(
              value: FilteringOption.all,
              child: Text('Show all '),
            )
          ]);
}
