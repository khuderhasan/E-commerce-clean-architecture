import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/shared_widgets/app_sanck_bar.dart';
import '../../../../core/shared_widgets/error_dialog.dart';
import '../bloc/orders_bloc.dart';

import '../../../../providers/cart_provider.dart';

class OrderButton extends StatelessWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrdersBloc, OrdersState>(
      bloc: context.read<OrdersBloc>()..add(GetOrdersEvent()),
      listener: (context, state) {
        if (state is SuccessAddOrderState) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar(reason: SnackBarClosedReason.hide)
            ..showSnackBar(appSnackBar(text: state.message));
        } else if (state is ErrorOrdersState) {
          showErrorDialog(context, state.errorMessage);
        }
      },
      builder: (context, state) {
        return TextButton(
          onPressed: (cart.getTotal <= 0 || state is LoadingOrdersState)
              ? null
              : () async {
                  context.read<OrdersBloc>().add(
                        AddOrderEvent(
                            cartProducts: cart.items.values.toList(),
                            finalPrice: cart.getTotal),
                      );

                  cart.clearCart();
                },
          child: state is LoadingOrdersState
              ? const CircularProgressIndicator()
              : Text(
                  'PLACE ORDER',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
        );
      },
    );
  }
}
