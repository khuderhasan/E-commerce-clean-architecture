part of 'add_update_delete_product_bloc_bloc.dart';

abstract class AddUpdateDeleteProductState extends Equatable {
  const AddUpdateDeleteProductState();

  @override
  List<Object> get props => [];
}

class InitialAddUpdateDeleteProductState extends AddUpdateDeleteProductState {}

class LoadingAddUpdateDeleteProductState extends AddUpdateDeleteProductState {}

class SuccessAddUpdateDeleteProductState extends AddUpdateDeleteProductState {
  final String message;

  const SuccessAddUpdateDeleteProductState({required this.message});
}

class ErrorAddUpdateDeleteProductState extends AddUpdateDeleteProductState {
  final String errorMessage;

  const ErrorAddUpdateDeleteProductState({
    required this.errorMessage,
  });
}
