import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/domain/enums/wish_status.dart';
import 'package:wishlist/domain/models/wish.dart';
import 'package:wishlist/domain/usecases/create_wish_usecase.dart';
import 'package:wishlist/domain/usecases/delete_wish_usecase.dart';
import 'package:wishlist/domain/usecases/edit_wish_usecase.dart';
import 'package:wishlist/domain/usecases/get_wish_by_uid_usecase.dart';
import 'package:wishlist/ui/common/enums/wish_page_type.dart';
import 'package:wishlist/ui/wish_page/common/enums/price_indication_mode.dart';

part 'wish_page_event.dart';

part 'wish_page_state.dart';

// TODO: реализовать проверки полей и тексты ошибок
class WishPageBloc extends Bloc<WishPageEvent, WishPageState> {
  final CreateWishUseCase _createWishUseCase;
  final EditWishUseCase _editWishUseCase;
  final GetWishByUidUseCase _getWishByUidUseCase;
  final DeleteWishUseCase _deleteWishUseCase;
  TextEditingController? fieldNameController;
  TextEditingController? fieldDescriptionController;
  TextEditingController? fieldLinkController;
  TextEditingController? price1Controller;
  TextEditingController? price2Controller;
  ScrollController? scrollController;
  FocusNode? linkFieldFocusNode;
  StreamSubscription? _streamSubscription;

  WishPageBloc(
      {required CreateWishUseCase createWishUseCase,
      required EditWishUseCase editWishUseCase,
        required GetWishByUidUseCase getWishByUidUseCase,
        required DeleteWishUseCase deleteWishUseCase,
      required WishPageType wishPageType,
      required Wish? initWish})
      : _createWishUseCase = createWishUseCase,
        _editWishUseCase = editWishUseCase,
  _getWishByUidUseCase = getWishByUidUseCase,
        _deleteWishUseCase = deleteWishUseCase,
        super(_getInitialState(wishPageType, initWish)) {
    _init(wishPageType: wishPageType, initWish: initWish);
  }

  static WishPageState _getInitialState(WishPageType wishPageType, Wish? wish) {
    if (wishPageType == WishPageType.create) {
      return CreateWishState.empty();
    } else if (wishPageType == WishPageType.edit) {
      return wish != null
          ? EditWishState.initFromWish(wish)
          : CreateWishState.empty();
    } else {
      if (wish != null) {
        return ViewWishState(wish: wish);
      } else {
        return const ViewWishState(
            wish: null,
            errorMessage: 'Ошибка открытия желания',
            isLoading: true);
      }
    }
  }

  void _init({required WishPageType wishPageType, required Wish? initWish}) {
    if (wishPageType == WishPageType.create ||
        wishPageType == WishPageType.edit) {
      fieldNameController = TextEditingController(text: initWish?.name);
      fieldDescriptionController =
          TextEditingController(text: initWish?.description);
      fieldLinkController = TextEditingController();
      price1Controller = TextEditingController(text: '${initWish?.price?.$1}');
      price2Controller = TextEditingController(text: '${initWish?.price?.$2}');
      scrollController = ScrollController();
      linkFieldFocusNode = FocusNode();

      linkFieldFocusNode?.addListener(() {
        if (!linkFieldFocusNode!.hasFocus) {
          add(const SaveLinkEvent());
        }
      });
    }

    if(wishPageType == WishPageType.view && initWish != null){
      final Stream<Wish> streamWish = _getWishByUidUseCase.run(uid: initWish.uid!);
      _streamSubscription = streamWish.listen((data) {
        add(UpdateWishFieldsEvent(wish: data));
      }, onError: (error) {});
    }

    on<UpdateWishFieldsEvent>(_onUpdateWishFields);
    on<SaveWishEvent>(_onSaveWish);
    on<AddNewLinkTextFieldEvent>(_onAddNewLinkTextField);
    on<SaveLinkEvent>(_onSaveLink);
    on<RemoveLinkEvent>(_onRemoveLink);
    on<EditLinkEvent>(_onEditLink);
    on<CheckPriceIndicationModeEvent>(_onCheckPriceIndicationMode);
    on<AddImagesEvent>(_onAddImages);
    on<DeleteWishEvent>(_onDeleteWish);
  }

  void _onDeleteWish(
      DeleteWishEvent event,
      Emitter<WishPageState> emit,
      ) {
    if(state is ViewWishState && (state as ViewWishState).wish != null){
      _deleteWishUseCase.run(((state as ViewWishState).wish!.uid!));
      emit(const ViewWishState(wish: null, isWishDeleted: true));
    }
  }

  void _onUpdateWishFields(
      UpdateWishFieldsEvent event,
      Emitter<WishPageState> emit,
      ) {
    emit(ViewWishState(wish: event.wish));
  }

  (double, double?)? _getPriceFromFields() {
    (double, double?)? price;
    if ((state as WishEditable).priceIndicationMode ==
        PriceIndicationMode.onePrice) {
      double price1 = _getDoubleFromController(price1Controller);
      price = (price1, null);
    } else if ((state as WishEditable).priceIndicationMode ==
        PriceIndicationMode.priceRange) {
      double price1 = _getDoubleFromController(price1Controller);
      double price2 = _getDoubleFromController(price2Controller);
      price = (price1, price2);
    }
    return price;
  }

  double _getDoubleFromController(TextEditingController? controller) =>
      controller != null && controller.text.isNotEmpty
          ? double.parse(controller.text)
          : 0.0;

  void _onSaveWish(
    SaveWishEvent event,
    Emitter<WishPageState> emit,
  ) async {
    WishEditable currentState = state as WishEditable;
    String name = fieldNameController?.text ?? '';

    if (name.isEmpty) {
      emit(currentState
          .copyWith(error: (true, 'Название желания - обязательное поле')));
    } else {
      if (state is CreateWishState) {
        _createWishUseCase.run(Wish(
            name: name,
            description: fieldDescriptionController?.text ?? '',
            status: WishStatus.undone,
            urls: currentState.urls,
            images: currentState.images,
            price: _getPriceFromFields()));
      } else {
        _editWishUseCase.run((state as EditWishState).wish,
            name: name,
            description: fieldDescriptionController?.text,
            urls: currentState.urls,
            images: currentState.images,
            price: _getPriceFromFields(),
            resetPrice: true);
      }

      emit(currentState.copyWith(successSave: true));
    }
  }

  void _onAddNewLinkTextField(
    AddNewLinkTextFieldEvent event,
    Emitter<WishPageState> emit,
  ) {
    fieldLinkController?.clear();
    emit((state as WishEditable).copyWith(showAddLinkButton: false));
    linkFieldFocusNode?.requestFocus();
  }

  void _onSaveLink(
    SaveLinkEvent event,
    Emitter<WishPageState> emit,
  ) {
    String? newLink = fieldLinkController?.text;
    emit((state as WishEditable).copyWith(
        showAddLinkButton: true,
        urls: newLink != null && newLink.isNotEmpty
            ? [...(state as WishEditable).urls, newLink]
            : null));
    fieldLinkController?.clear();
  }

  void _onRemoveLink(
    RemoveLinkEvent event,
    Emitter<WishPageState> emit,
  ) {
    List<Link> newUrls = List.from((state as WishEditable).urls);
    newUrls.remove(event.url);
    emit((state as WishEditable).copyWith(urls: newUrls));
  }

  void _onEditLink(
    EditLinkEvent event,
    Emitter<WishPageState> emit,
  ) {
    List<Link> newUrls = List.from((state as WishEditable).urls);
    newUrls.remove(event.url);
    fieldLinkController?.text = event.url;
    emit((state as WishEditable)
        .copyWith(showAddLinkButton: false, urls: newUrls));
    linkFieldFocusNode?.requestFocus();
  }

  void _onCheckPriceIndicationMode(
    CheckPriceIndicationModeEvent event,
    Emitter<WishPageState> emit,
  ) {
    if ((state as WishEditable).priceIndicationMode != event.mode) {
      price1Controller?.clear();
      price2Controller?.clear();
      emit((state as WishEditable).copyWith(priceIndicationMode: event.mode));

      if (event.mode == PriceIndicationMode.onePrice &&
          scrollController != null) {
        scrollController?.jumpTo(scrollController!.offset + 44);
      } else if (event.mode == PriceIndicationMode.priceRange &&
          scrollController != null) {
        scrollController?.jumpTo(scrollController!.offset + 84);
      }
    }
  }

  void _onAddImages(
    AddImagesEvent event,
    Emitter<WishPageState> emit,
  ) {
    emit((state as WishEditable).copyWith(images: event.images));
  }

  @override
  Future<void> close() {
    fieldNameController?.dispose();
    fieldDescriptionController?.dispose();
    fieldLinkController?.dispose();
    price1Controller?.dispose();
    price2Controller?.dispose();
    scrollController?.dispose();
    linkFieldFocusNode?.dispose();
    _streamSubscription?.cancel();
    return super.close();
  }
}
