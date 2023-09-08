import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shop_app_clean_architecture/features/orders/data/datasources/orders_remote_datasource.dart';
import 'package:shop_app_clean_architecture/features/orders/data/repositories/orders_repositroy_impl.dart';
import 'package:shop_app_clean_architecture/features/orders/domain/usecase/add_order_usecase.dart';
import 'package:shop_app_clean_architecture/features/orders/domain/usecase/get_orders_usecase.dart';
import 'package:shop_app_clean_architecture/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:shop_app_clean_architecture/features/products/domain/usecases/toggle_favourite.dart';
import 'package:shop_app_clean_architecture/features/products/presentaion/BLoCs/bloc/toggle_favourite_bloc.dart';
import '../network/network_info.dart';
import '../../features/products/domain/usecases/add_product.dart';
import '../../features/products/domain/usecases/delete_product.dart';
import '../../features/products/domain/usecases/update_product.dart';
import '../../features/products/presentaion/Blocs/add_update_delete_product_bloc/add_update_delete_product_bloc_bloc.dart';
import '../../features/products/data/datasourse/product_remote_datasource.dart';
import '../../features/products/data/repository/product_repository_impl.dart';
import '../../features/products/domain/usecases/get_all_products.dart';
import '../../features/products/domain/usecases/get_user_products.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/signup_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/products/presentaion/Blocs/products_bloc/get_products_bloc.dart';
import '../../providers/current_user.dart';

final sl = GetIt.instance;
Future<void> init() async {
//! Auth Feature

//* Providers

  sl.registerSingleton(CurrentUser());

//* Bloc

  sl.registerFactory(() => AuthBloc(login: sl(), signUp: sl()));

//* UseCases

  sl.registerLazySingleton<LoginUsecase>(
      () => LoginUsecase(repository: sl<AuthRepositoryImpl>()));

  sl.registerLazySingleton<SignUpUsecase>(
      () => SignUpUsecase(repository: sl<AuthRepositoryImpl>()));

//* Repositories

  sl.registerLazySingleton<AuthRepositoryImpl>(() =>
      AuthRepositoryImpl(remoteDatasource: sl<AuthRemoteDatasourceImpl>()));

//* DataSources

  sl.registerLazySingleton<AuthRemoteDatasourceImpl>(
      () => AuthRemoteDatasourceImpl(client: sl<http.Client>()));

//! Externals

  sl.registerLazySingleton<http.Client>(() => http.Client());
  sl.registerLazySingleton<InternetConnectionChecker>(
      () => InternetConnectionChecker());

//! Core
  sl.registerLazySingleton<NetworkInfoImpl>(
      () => NetworkInfoImpl(sl<InternetConnectionChecker>()));

//! Products

//* Bloc

  sl.registerFactory(
    () => GetProductsBloc(
        getAllProducts: sl<GetAllProductsUsecase>(),
        getUserProducts: sl<GetUserProductsUsecase>()),
  );
  sl.registerFactory(() => AddUpdateDeleteProductBloc(
      addproduct: sl<AddProductUsecase>(),
      updateProduct: sl<UpdateProductUsecase>(),
      delteProduct: sl<DeleteProductUsecase>()));

  sl.registerFactory(
      () => ToggleFavouriteBloc(toggleFavourite: sl<ToggleFavouriteUsecase>()));

  //* UseCases

  sl.registerLazySingleton<GetAllProductsUsecase>(
      () => GetAllProductsUsecase(repository: sl<ProductsRepositoryImpl>()));

  sl.registerLazySingleton<GetUserProductsUsecase>(
      () => GetUserProductsUsecase(repository: sl<ProductsRepositoryImpl>()));

  sl.registerLazySingleton<AddProductUsecase>(
      () => AddProductUsecase(repository: sl<ProductsRepositoryImpl>()));

  sl.registerLazySingleton<UpdateProductUsecase>(
      () => UpdateProductUsecase(repository: sl<ProductsRepositoryImpl>()));

  sl.registerLazySingleton<DeleteProductUsecase>(
      () => DeleteProductUsecase(repository: sl<ProductsRepositoryImpl>()));

  sl.registerLazySingleton<ToggleFavouriteUsecase>(
      () => ToggleFavouriteUsecase(repository: sl<ProductsRepositoryImpl>()));

  //* Repositories

  sl.registerLazySingleton<ProductsRepositoryImpl>(() => ProductsRepositoryImpl(
      remoteDatasource: sl<ProductsRemoteDatasourceImpl>(),
      networkInfoImpl: sl<NetworkInfoImpl>()));

  //* DataSources

  sl.registerLazySingleton(
      () => ProductsRemoteDatasourceImpl(client: sl<http.Client>()));

  //! Orders

  //* Bloc
  sl.registerFactory(() => OrdersBloc(
      addOrder: sl<AddOrderUsecase>(), getOrders: sl<GetOrdersUsecase>()));

  //*UseCases

  sl.registerLazySingleton<AddOrderUsecase>(
      () => AddOrderUsecase(repository: sl<OrdersRepositoryImpl>()));

  sl.registerLazySingleton<GetOrdersUsecase>(
      () => GetOrdersUsecase(repository: sl<OrdersRepositoryImpl>()));

  //* Repositories

  sl.registerLazySingleton<OrdersRepositoryImpl>(() => OrdersRepositoryImpl(
      networkInfo: sl<NetworkInfoImpl>(),
      remoteDataSource: sl<OrdersRemoteDataSourceImpl>()));

  //* DataSources

  sl.registerLazySingleton<OrdersRemoteDataSourceImpl>(
      () => OrdersRemoteDataSourceImpl(client: sl<http.Client>()));
}
