import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Blocs/add_update_delete_product_bloc/add_update_delete_product_bloc_bloc.dart';
import '../widgets/app_drawer.dart';

import '../../../../core/shared_widgets/app_sanck_bar.dart';
import '../../../../core/shared_widgets/error_dialog.dart';
import '../Blocs/products_bloc/get_products_bloc.dart';
import '../widgets/user_products_list.dart';
import 'edit_product_screen.dart';

class ManageUserProductsScreen extends StatelessWidget {
  const ManageUserProductsScreen({super.key});
  static const routeName = '/user-products';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        drawer: const AppDrawer(),
        body: BlocConsumer<AddUpdateDeleteProductBloc,
            AddUpdateDeleteProductState>(
          bloc: BlocProvider.of<AddUpdateDeleteProductBloc>(context),
          listener: (context, state) {
            if (state is SuccessAddUpdateDeleteProductState) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar(reason: SnackBarClosedReason.hide)
                ..showSnackBar(appSnackBar(text: state.message));
            } else if (state is ErrorAddUpdateDeleteProductState) {
              showErrorDialog(context, state.errorMessage);
            }
          },
          builder: (context, state) =>
              BlocBuilder<GetProductsBloc, GetProductsState>(
                  bloc: context.read<GetProductsBloc>()
                    ..add(GetUserProductsEvent()),
                  builder: (context, state) {
                    if (state is GetProductsLoadedState) {
                      return UserProductsList(productsData: state.productsList);
                    } else if (state is GetProductsErrorState) {
                      return Center(
                        child: Text(state.errorMessage),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
        ));
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Your Products'),
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.of(context)
                .pushNamed(EditProductScreen.routeName, arguments: null);
          },
        )
      ],
    );
  }
}
