import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/usecases/toggle_favourite.dart';

part 'toggle_favourite_event.dart';
part 'toggle_favourite_state.dart';

class ToggleFavouriteBloc
    extends Bloc<ToggleFavouriteEvent, ToggleFavouriteState> {
  final ToggleFavouriteUsecase toggleFavourite;
  ToggleFavouriteBloc({required this.toggleFavourite})
      : super(ToggleFavouriteLoading()) {
    on<ToggleFavouriteEvent>((event, emit) async {
      if (event is FavouriteEvent) {
        emit(ToggleFavouriteLoading());
        final successOrFailure =
            await toggleFavourite(event.currentFavouriteState, event.productId);
        print("the event was fired from inside the bloc");
        emit(_mapSuccessOrFailure(
            successOrFailure, event.currentFavouriteState));
      }
    });
  }
}

ToggleFavouriteState _mapSuccessOrFailure(
    Either<Failure, Unit> either, bool currentFavouriteState) {
  return either.fold((failure) {
    if (failure.runtimeType == OfflineFailure) {
      return const ToggleFavouriteFailure(
          errorMessage: "Sorry , You are Offline");
    }
    return const ToggleFavouriteFailure(
        errorMessage: "Sorry , Could not Get Products");
  },
      (sucesss) => ToggleFavouriteSuccess(
          message: "Product added to Favourites",
          newFavouriteState: !currentFavouriteState));
}
