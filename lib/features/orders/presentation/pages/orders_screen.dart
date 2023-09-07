import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/orders_bloc.dart';
import '../../../products/presentaion/widgets/app_drawer.dart';

import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        bloc: context.read<OrdersBloc>()..add(GetOrdersEvent()),
        builder: (context, state) {
          if (state is ErrorOrdersState) {
            return Center(
              child: Text(state.errorMessage),
            );
          } else if (state is LoadedOrdersState) {
            if (state.loadedOrders.isEmpty) {
              return const Center(
                child: Text("No Orders Yet"),
              );
            } else {
              return ListView.builder(
                  itemCount: state.loadedOrders.length,
                  itemBuilder: (context, i) =>
                      OrderItem(order: state.loadedOrders[i]));
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      drawer: const AppDrawer(),
    );
  }
}

AppBar _buildAppBar() {
  return AppBar(
    title: const Text("Your Orders"),
  );
}
