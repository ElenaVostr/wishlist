import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:wishlist/domain/enums/wish_status.dart';
import 'package:wishlist/domain/models/wish.dart';
import 'package:wishlist/domain/usecases/create_wish_usecase.dart';
import 'package:wishlist/ui/common/enums/wish_page_type.dart';
import 'package:wishlist/ui/wish_page/common/enums/price_indication_mode.dart';

part 'wish_page_event.dart';

part 'wish_page_state.dart';

// TODO: реализовать проверки полей и тексты ошибок
class WishPageBloc extends Bloc<WishPageEvent, WishPageState> {
  final CreateWishUseCase _createWishUseCase;
  TextEditingController? fieldNameController;
  TextEditingController? fieldDescriptionController;
  TextEditingController? fieldLinkController;
  TextEditingController? price1Controller;
  TextEditingController? price2Controller;
  ScrollController? scrollController;
  FocusNode? linkFieldFocusNode;

  WishPageBloc(
      {required CreateWishUseCase createWishUseCase,
      required WishPageType wishPageType,
      required Wish? initWish})
      : _createWishUseCase = createWishUseCase,
        super(_getInitialState(wishPageType, initWish)) {
    _init();
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

  void _init() {
    fieldNameController = TextEditingController();
    fieldDescriptionController = TextEditingController();
    fieldLinkController = TextEditingController();
    price1Controller = TextEditingController();
    price2Controller = TextEditingController();
    scrollController = ScrollController();
    linkFieldFocusNode = FocusNode();

    linkFieldFocusNode?.addListener(() {
      print('Слушаю фокус');
      if (!linkFieldFocusNode!.hasFocus) {
        print('Клавиатура закрыта');
        add(const SaveLinkEvent());
      }
    });

    on<SaveNewWishEvent>(_onSaveNewWish);
    on<AddNewLinkTextFieldEvent>(_onAddNewLinkTextField);
    on<SaveLinkEvent>(_onSaveLink);
    on<RemoveLinkEvent>(_onRemoveLink);
    on<EditLinkEvent>(_onEditLink);
    on<CheckPriceIndicationModeEvent>(_onCheckPriceIndicationMode);
    on<AddImagesEvent>(_onAddImages);
  }

  void _onSaveNewWish(
    SaveNewWishEvent event,
    Emitter<WishPageState> emit,
  ) async {
    WishEditable currentState = state as WishEditable;

    String name = fieldNameController?.text ?? '';
    String description = fieldDescriptionController?.text ?? '';

    if (name.isEmpty) {
      emit(currentState
          .copyWith(error: (true, 'Название желания - обязательное поле')));
    } else {
      (double, double?)? price;
      if (currentState.priceIndicationMode == PriceIndicationMode.onePrice) {
        double price1 = price1Controller != null
            ? double.parse(price1Controller!.text)
            : 0.0;
        price = (price1, null);
      } else if (currentState.priceIndicationMode ==
          PriceIndicationMode.priceRange) {
        double price1 = price1Controller != null
            ? double.parse(price1Controller!.text)
            : 0.0;
        double price2 = price2Controller != null
            ? double.parse(price2Controller!.text)
            : 0.0;
        price = (price1, price2);
      }

      // String? imagePreviewStr;
      // final Uint8List? imagePreviewResponse =
      // await FlutterImageCompress.compressWithFile(
      //   currentState.images.first.path,
      //   quality: 15,
      // );
      // print(imagePreviewResponse);
      // if (imagePreviewResponse != null) {
      //   //imagePreviewStr = utf8.decode(imagePreviewResponse, allowMalformed: true);
      //   imagePreviewStr = String.fromCharCodes(imagePreviewResponse);
      // }

      _createWishUseCase.run(Wish(
          name: name,
          description: description,
          status: WishStatus.undone,
          urls: currentState.urls,
          images: currentState.images,
          imagePreview: null,
          price: price));

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
    return super.close();
  }
}
