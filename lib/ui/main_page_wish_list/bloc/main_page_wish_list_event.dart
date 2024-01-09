part of 'main_page_wish_list_bloc.dart';

abstract class MainPageWishListEvent {
  const MainPageWishListEvent();
}

class CreateWishEvent extends MainPageWishListEvent {
  const CreateWishEvent();
}

class LoadWishListEvent extends MainPageWishListEvent with EquatableMixin {
  const LoadWishListEvent();

  @override
  List<Object?> get props => [];
}


class WishListLoadedEvent extends MainPageWishListEvent with EquatableMixin {
  final List<Wish> wishList;

  const WishListLoadedEvent({required this.wishList});

  @override
  List<Object?> get props => [wishList];
}


class ErrorEvent extends MainPageWishListEvent with EquatableMixin {
  final String errorMessage;

  const ErrorEvent({required this.errorMessage});

  @override
  List<Object?> get props => [errorMessage];
}
