import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';
import '../../../domain/usecases/add_product.dart';
import '../../../domain/usecases/delete_product.dart';
import '../../../domain/usecases/update_product.dart';

import '../../../../../core/error/failures.dart';

part 'add_update_delete_product_bloc_event.dart';
part 'add_update_delete_product_bloc_state.dart';

class AddUpdateDeleteProductBloc
    extends Bloc<AddUpdateDeleteProductEvent, AddUpdateDeleteProductState> {
  final AddProductUsecase addproduct;
  final UpdateProductUsecase updateProduct;
  final DeleteProductUsecase delteProduct;
  AddUpdateDeleteProductBloc(
      {required this.addproduct,
      required this.updateProduct,
      required this.delteProduct})
      : super(InitialAddUpdateDeleteProductState()) {
    on<AddUpdateDeleteProductEvent>((event, emit) async {
      if (event is AddProductEvent) {
        emit(LoadingAddUpdateDeleteProductState());
        final successOrFailure = await addproduct(newProduct: event.newProduct);
        emit(_eitherSuccessMessageOrFailureToState(
            successOrFailure, "Product Added Successfully"));
      } else if (event is UpdateProductEvent) {
        emit(LoadingAddUpdateDeleteProductState());
        final successOrFailure = await updateProduct(
          updatedProduct: event.updatedProduct,
          productId: event.productId,
        );
        emit(_eitherSuccessMessageOrFailureToState(
            successOrFailure, "Product Updated Successfully"));
      } else if (event is DeleteProductEvent) {
        emit(LoadingAddUpdateDeleteProductState());
        final successOrFailure = await delteProduct(productId: event.productId);
        emit(_eitherSuccessMessageOrFailureToState(
            successOrFailure, "Product Deleted Successfully"));
      }
    });
  }
  AddUpdateDeleteProductState _eitherSuccessMessageOrFailureToState(
      Either<Failure, Unit> either, String message) {
    return either.fold((failuer) {
      if (failuer.runtimeType == OfflineFailure) {
        return const ErrorAddUpdateDeleteProductState(
            errorMessage: "Sorry you are offline");
      }
      return const ErrorAddUpdateDeleteProductState(
          errorMessage: "Something went Wrong with the server");
    }, (success) => SuccessAddUpdateDeleteProductState(message: message));
  }
}
