import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/domain/models/wish.dart';
import 'package:wishlist/domain/usecases/create_wish_usecase.dart';
import 'package:wishlist/domain/usecases/get_wish_list_stream_usecase.dart';
import 'package:wishlist/ui/main_page_wish_list/bloc/main_page_wish_list_bloc.dart';

class MainPageWishListCubit extends Cubit<MainPageWishListState> {
  final GetWishListStreamUseCase _getWishListStreamUseCase;
  final CreateWishUseCase _createWishUseCase;

  MainPageWishListCubit({
    required GetWishListStreamUseCase getWishListStreamUseCase,
    required CreateWishUseCase createWishUseCase,
  })  : _getWishListStreamUseCase = getWishListStreamUseCase,
        _createWishUseCase = createWishUseCase,
        super(const LoadingState()) {
    _init();
  }

  StreamSubscription? _streamSubscription;

  void _init() {
    final Stream<List<Wish>> streamWishList = _getWishListStreamUseCase.run();
    _streamSubscription = streamWishList.listen((data) {
      emit(WishListLoadedState(wishList: data));
    }, onError: (error) {
      emit(ErrorState(errorMessage: error.toString()));
    });
  }

  void createWish() {
    _createWishUseCase.run(const Wish(name: 'новое желание'));
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}
