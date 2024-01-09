import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/domain/models/wish.dart';
import 'package:wishlist/domain/usecases/create_wish_usecase.dart';
import 'package:wishlist/domain/usecases/get_wish_list_stream_usecase.dart';

part 'main_page_wish_list_event.dart';

part 'main_page_wish_list_state.dart';

class MainPageWishListBloc
    extends Bloc<MainPageWishListEvent, MainPageWishListState> {
  final GetWishListStreamUseCase _getWishListStreamUseCase;
  final CreateWishUseCase _createWishUseCase;

  MainPageWishListBloc({
    required GetWishListStreamUseCase getWishListStreamUseCase,
    required CreateWishUseCase createWishUseCase,
  })  : _getWishListStreamUseCase = getWishListStreamUseCase,
        _createWishUseCase = createWishUseCase,
        super(const LoadingState()) {
    _init();
  }

  StreamSubscription? _streamSubscription;

  void _init() {
    on<LoadWishListEvent>((event, emit) {
      final Stream<List<Wish>> streamWishList = _getWishListStreamUseCase.run();
      _streamSubscription = streamWishList.listen((data) {
        add(WishListLoadedEvent(wishList: data));
      }, onError: (error) {
        add(ErrorEvent(errorMessage: error.toString()));
      });
    });

    on<WishListLoadedEvent>((event, emit) {
     emit(WishListLoadedState(wishList: event.wishList));
    });

    on<ErrorEvent>((event, emit) {
      emit(ErrorState(errorMessage: event.errorMessage));
    });

    on<CreateWishEvent>((event, emit) {
      _createWishUseCase.run(const Wish(name: 'новое желание'));
    });

    add(const LoadWishListEvent());
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }
}