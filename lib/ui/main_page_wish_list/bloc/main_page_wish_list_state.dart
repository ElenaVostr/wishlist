part of 'main_page_wish_list_bloc.dart';

abstract class MainPageWishListState extends Equatable {
  const MainPageWishListState();
}

class LoadingState extends MainPageWishListState {
  @override
  List<Object?> get props => [];

  const LoadingState();
}

class ErrorState extends MainPageWishListState {
  final String errorMessage;

  const ErrorState({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}

class WishListLoadedState extends MainPageWishListState {
  final List<Wish> wishList;

  const WishListLoadedState({required this.wishList});

  @override
  List<Object?> get props => [wishList];
}
