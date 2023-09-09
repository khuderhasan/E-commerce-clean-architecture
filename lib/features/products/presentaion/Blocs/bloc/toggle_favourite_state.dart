part of 'toggle_favourite_bloc.dart';

abstract class ToggleFavouriteState extends Equatable {
  const ToggleFavouriteState();

  @override
  List<Object> get props => [];
}

class ToggleFavouriteLoading extends ToggleFavouriteState {}

class ToggleFavouriteSuccess extends ToggleFavouriteState {
  final String message;
  final bool newFavouriteState;
  const ToggleFavouriteSuccess({
    required this.message,
    required this.newFavouriteState,
  });
}

class ToggleFavouriteFailure extends ToggleFavouriteState {
  final String errorMessage;

  const ToggleFavouriteFailure({
    required this.errorMessage,
  });
}
