part of 'wish_page_bloc.dart';

sealed class WishPageState extends Equatable {
  const WishPageState();
}

/// Интерфейс с общими полями для [CreateWishState] и [EditWishState]
abstract class WishEditable extends WishPageState {
  List<Link> get urls;

  List<Link> get images;

  String get listWishUid;

  PriceIndicationMode get priceIndicationMode;

  bool get showAddLinkButton;

  bool get successSave;

  (bool, String?) get error;

  WishPageState copyWith(
      {List<Link>? images,
      List<Link>? urls,
      String? listWishUid,
      PriceIndicationMode? priceIndicationMode,
      bool? showAddLinkButton,
      bool? successSave,
      (bool, String?) error});
}

/// Состояние страницы просмотра желания
class ViewWishState extends WishPageState {
  final Wish? wish;
  final String? errorMessage;
  final bool isLoading;
  final bool isWishDeleted;

  const ViewWishState(
      {required this.wish, this.errorMessage, this.isLoading = false, this.isWishDeleted = false});

  @override
  List<Object?> get props => [wish, errorMessage, isLoading, isWishDeleted];
}

/// Состояние страницы редактирования желания
class EditWishState extends WishPageState implements WishEditable {
  final Wish wish;

  const EditWishState(
      {required this.wish,
      required this.images,
      required this.urls,
      required this.listWishUid,
      required this.priceIndicationMode,
      this.showAddLinkButton = true,
      this.successSave = false,
      this.error = (false, null)});

  factory EditWishState.initFromWish(Wish wish) {
    PriceIndicationMode initPriceIndicationMode;
    if (wish.price == null) {
      initPriceIndicationMode = PriceIndicationMode.priceNotSpecified;
    } else if (wish.price!.$2 == null) {
      initPriceIndicationMode = PriceIndicationMode.onePrice;
    } else if (wish.price!.$2 != null) {
      initPriceIndicationMode = PriceIndicationMode.priceRange;
    } else {
      initPriceIndicationMode = PriceIndicationMode.priceNotSpecified;
    }

    return EditWishState(
        wish: wish,
        images: wish.images,
        urls: wish.urls,
        listWishUid: '',
        priceIndicationMode: initPriceIndicationMode);
  }

  @override
  List<Object?> get props => [
        wish,
        images,
        urls,
        listWishUid,
        priceIndicationMode,
        showAddLinkButton,
        successSave,
        error
      ];

  @override
  EditWishState copyWith(
      {List<Link>? images,
      List<Link>? urls,
      String? listWishUid,
      PriceIndicationMode? priceIndicationMode,
      bool? showAddLinkButton,
      bool? successSave,
      (bool, String?)? error}) {
    return EditWishState(
      wish: wish,
      images: images ?? this.images,
      urls: urls ?? this.urls,
      listWishUid: listWishUid ?? this.listWishUid,
      priceIndicationMode: priceIndicationMode ?? this.priceIndicationMode,
      showAddLinkButton: showAddLinkButton ?? this.showAddLinkButton,
      successSave: successSave ?? this.successSave,
      error: error ?? (false, null),
    );
  }

  @override
  final List<Link> images;

  @override
  final List<Link> urls;

  @override
  final String listWishUid;

  @override
  final PriceIndicationMode priceIndicationMode;

  @override
  final bool showAddLinkButton;

  @override
  final bool successSave;

  @override
  final (bool, String?) error;
}

/// Состояние страницы создания желания
class CreateWishState extends WishPageState implements WishEditable {
  const CreateWishState(
      {required this.images,
      required this.urls,
      required this.listWishUid,
      required this.priceIndicationMode,
      required this.showAddLinkButton,
      this.successSave = false,
      this.error = (false, null)});

  factory CreateWishState.empty() {
    return const CreateWishState(
        images: <Link>[],
        urls: <Link>[],
        listWishUid: '',
        priceIndicationMode: PriceIndicationMode.priceNotSpecified,
        showAddLinkButton: true);
  }

  @override
  CreateWishState copyWith(
      {List<Link>? images,
      List<Link>? urls,
      String? listWishUid,
      PriceIndicationMode? priceIndicationMode,
      bool? showAddLinkButton,
      bool? successSave,
      (bool, String?)? error}) {
    return CreateWishState(
      images: images ?? this.images,
      urls: urls ?? this.urls,
      listWishUid: listWishUid ?? this.listWishUid,
      priceIndicationMode: priceIndicationMode ?? this.priceIndicationMode,
      showAddLinkButton: showAddLinkButton ?? this.showAddLinkButton,
      successSave: successSave ?? this.successSave,
      error: error ?? (false, null),
    );
  }

  @override
  List<Object?> get props => [
        images,
        urls,
        listWishUid,
        priceIndicationMode,
        showAddLinkButton,
        successSave,
        error
      ];

  @override
  final List<Link> images;

  @override
  final List<Link> urls;

  @override
  final String listWishUid;

  @override
  final PriceIndicationMode priceIndicationMode;

  @override
  final bool showAddLinkButton;

  @override
  final bool successSave;

  @override
  final (bool, String?) error;
}
