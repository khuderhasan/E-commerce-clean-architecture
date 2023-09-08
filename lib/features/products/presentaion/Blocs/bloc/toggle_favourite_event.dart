part of 'toggle_favourite_bloc.dart';

abstract class ToggleFavouriteEvent extends Equatable {
  const ToggleFavouriteEvent();

  @override
  List<Object> get props => [];
}

class FavouriteEvent extends ToggleFavouriteEvent {
  final bool currentFavouriteState;
  final String productId;
  const FavouriteEvent({
    required this.currentFavouriteState,
    required this.productId,
  });
}
