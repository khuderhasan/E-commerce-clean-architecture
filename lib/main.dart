import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shop_app_clean_architecture/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:shop_app_clean_architecture/features/orders/presentation/pages/cart_screen.dart';
import 'package:shop_app_clean_architecture/features/orders/presentation/pages/orders_screen.dart';
import 'package:shop_app_clean_architecture/features/products/presentaion/BLoCs/bloc/toggle_favourite_bloc.dart';
import 'package:shop_app_clean_architecture/providers/cart_provider.dart';
import 'features/products/presentaion/Blocs/add_update_delete_product_bloc/add_update_delete_product_bloc_bloc.dart';
import 'features/products/presentaion/pages/edit_product_screen.dart';
import 'features/products/presentaion/pages/manage_user_products_page.dart';
import 'features/products/presentaion/pages/products_page.dart';

import 'core/services/service_locator.dart' as di;
import 'core/strings/constatnts.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/auth_page.dart';
import 'features/products/presentaion/Blocs/products_bloc/get_products_bloc.dart';
import 'providers/current_user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CurrentUser()),
        ChangeNotifierProvider(create: (context) => Cart()),
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(
            create: (_) =>
                di.sl<GetProductsBloc>()..add(GetAllProductsEvent())),
        BlocProvider(create: (_) => di.sl<AddUpdateDeleteProductBloc>()),
        BlocProvider(
          create: (_) => di.sl<OrdersBloc>(),
        ),
        BlocProvider(create: (_) => di.sl<ToggleFavouriteBloc>())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shop App',
        theme: theme,
        home: const AuthPage(),
        routes: {
          ProductsPage.routeName: (context) => const ProductsPage(),
          ManageUserProductsScreen.routeName: (context) =>
              const ManageUserProductsScreen(),
          EditProductScreen.routeName: (context) => const EditProductScreen(),
          OrdersScreen.routeName: (context) => const OrdersScreen(),
          CartScreen.routeName: (context) => const CartScreen(),
        },
      ),
    );
  }
}
