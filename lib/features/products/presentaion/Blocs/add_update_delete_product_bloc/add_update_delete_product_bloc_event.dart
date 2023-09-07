part of 'add_update_delete_product_bloc_bloc.dart';

abstract class AddUpdateDeleteProductEvent extends Equatable {
  const AddUpdateDeleteProductEvent();

  @override
  List<Object> get props => [];
}

class AddProductEvent extends AddUpdateDeleteProductEvent {
  final Product newProduct;

  const AddProductEvent({required this.newProduct});
}

class UpdateProductEvent extends AddUpdateDeleteProductEvent {
  final Product updatedProduct;
  final String productId;

  const UpdateProductEvent({
    required this.updatedProduct,
    required this.productId,
  });
}

class DeleteProductEvent extends AddUpdateDeleteProductEvent {
  final String productId;

  const DeleteProductEvent({required this.productId});
}
