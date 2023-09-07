import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../../../../providers/cart_provider.dart';
import '../../../orders/presentation/pages/cart_screen.dart';
import '../../../orders/presentation/widgets/badge.dart';
import '../widgets/app_drawer.dart';

import '../Blocs/products_bloc/get_products_bloc.dart';
import '../widgets/pop_up_menue.dart';
import '../widgets/products_list.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});
  static const routeName = "/products_overview_screen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: const AppDrawer(),
      body: BlocBuilder<GetProductsBloc, GetProductsState>(
        bloc: context.read<GetProductsBloc>()..add(GetAllProductsEvent()),
        builder: (context, state) {
          if (state is GetProductsLoadedState) {
            return ProductsList(products: state.productsList);
          } else if (state is GetProductsErrorState) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    title: const Text('My Shop'),
    centerTitle: true,
    actions: [
      popUpMenueButtonWidget(context),
      Consumer<Cart>(
        builder: (_, cart, ch) => Badges(
          value: cart.itemCount.toString(),
          color: Colors.red,
          child: ch!,
        ),
        child: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, CartScreen.routeName);
          },
          icon: const Icon(Icons.add_shopping_cart),
        ),
      )
    ],
  );
}
