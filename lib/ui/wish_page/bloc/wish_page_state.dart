part of 'wish_page_bloc.dart';

abstract class WishPageState extends Equatable {
  const WishPageState();
}

//TODO: Убрать поля name, description, price1, price2
/// Интерфейс с общими полями для [CreateWishState] и [EditWishState]
abstract class WishEditable extends WishPageState {
  String get name;

  String get description;

  List<Link> get urls;

  List<Link> get images;

  String get listWishUid;

  double get price1;

  double get price2;

  PriceIndicationMode get priceIndicationMode;

  bool get showAddLinkButton;

  bool get successSave;

  (bool, String?) get error;

  WishPageState copyWith(
      {String? name,
      String? description,
      List<Link>? images,
      List<Link>? urls,
      String? listWishUid,
      double? price1,
      double? price2,
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

  const ViewWishState(
      {required this.wish, this.errorMessage, this.isLoading = false});

  @override
  List<Object?> get props => [wish, errorMessage, isLoading];
}

/// Состояние страницы редактирования желания
class EditWishState extends ViewWishState implements WishEditable {
  const EditWishState(
      {required super.wish,
      required this.name,
      required this.description,
      required this.images,
      required this.urls,
      required this.listWishUid,
      required this.price1,
      required this.price2,
      required this.priceIndicationMode,
      this.showAddLinkButton = true,
      this.successSave = false,
      this.error = (false, null)});

  factory EditWishState.initFromWish(Wish wish) {
    PriceIndicationMode initPriceIndicationMode;
    double initPrice1 = 0;
    double initPrice2 = 0;
    if (wish.price == null) {
      initPriceIndicationMode = PriceIndicationMode.priceNotSpecified;
    } else if (wish.price!.$2 == null) {
      initPriceIndicationMode = PriceIndicationMode.onePrice;
      initPrice1 = wish.price!.$1;
    } else if (wish.price!.$2 != null) {
      initPriceIndicationMode = PriceIndicationMode.priceRange;
      initPrice1 = wish.price!.$1;
      initPrice2 = wish.price!.$2!;
    } else {
      initPriceIndicationMode = PriceIndicationMode.priceNotSpecified;
    }

    return EditWishState(
        wish: wish,
        name: wish.name,
        description: wish.description,
        images: wish.images,
        urls: wish.urls,
        listWishUid: '',
        price1: initPrice1,
        price2: initPrice2,
        priceIndicationMode: initPriceIndicationMode);
  }

  @override
  List<Object?> get props => [
        ...super.props,
        name,
        description,
        images,
        urls,
        listWishUid,
        price1,
        price2,
        priceIndicationMode,
        showAddLinkButton,
        successSave,
        error
      ];

  @override
  EditWishState copyWith(
      {String? name,
      String? description,
      List<Link>? images,
      List<Link>? urls,
        String? listWishUid,
      double? price1,
      double? price2,
      PriceIndicationMode? priceIndicationMode,
      bool? showAddLinkButton,
      bool? successSave,
      (bool, String?)? error}) {
    return EditWishState(
      wish: super.wish,
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      urls: urls ?? this.urls,
      listWishUid: listWishUid ?? this.listWishUid,
      price1: price1 ?? this.price1,
      price2: price2 ?? this.price2,
      priceIndicationMode: priceIndicationMode ?? this.priceIndicationMode,
      showAddLinkButton: showAddLinkButton ?? this.showAddLinkButton,
      successSave: successSave ?? this.successSave,
      error: error ?? this.error,
    );
  }

  @override
  final String name;

  @override
  final String description;

  @override
  final List<Link> images;

  @override
  final List<Link> urls;

  @override
  final String listWishUid;

  @override
  final double price1;

  @override
  final double price2;

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
      {required this.name,
      required this.description,
      required this.images,
      required this.urls,
      required this.listWishUid,
      required this.price1,
      required this.price2,
      required this.priceIndicationMode,
      required this.showAddLinkButton,
      this.successSave = false,
      this.error = (false, null)});

  factory CreateWishState.empty() {
    return const CreateWishState(
        name: '',
        description: '',
        images: <Link>[],
        //urls: <Link>[],
        urls: <Link>[
          'https://ozon.ru/t/8VqAa8z',
          'https://ozon.ru/t/56jytjk6',
          'https://www.wildberries.ru/catalog/190211514/detail.aspx?targetUrl=SN'
        ],
        listWishUid: '',
        price1: 0,
        price2: 0,
        priceIndicationMode: PriceIndicationMode.priceNotSpecified,
        showAddLinkButton: true);
  }

  @override
  CreateWishState copyWith(
      {String? name,
      String? description,
      List<Link>? images,
      List<Link>? urls,
        String? listWishUid,
      double? price1,
      double? price2,
      PriceIndicationMode? priceIndicationMode,
      bool? showAddLinkButton,
      bool? successSave,
      (bool, String?)? error}) {
    return CreateWishState(
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      urls: urls ?? this.urls,
      listWishUid: listWishUid ?? this.listWishUid,
      price1: price1 ?? this.price1,
      price2: price2 ?? this.price2,
      priceIndicationMode: priceIndicationMode ?? this.priceIndicationMode,
      showAddLinkButton: showAddLinkButton ?? this.showAddLinkButton,
      successSave: successSave ?? this.successSave,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        name,
        description,
        images,
        urls,
        listWishUid,
        price1,
        price2,
        priceIndicationMode,
        showAddLinkButton,
        successSave,
        error
      ];

  @override
  final String name;

  @override
  final String description;

  @override
  final List<Link> images;

  @override
  final List<Link> urls;

  @override
  final String listWishUid;

  @override
  final double price1;

  @override
  final double price2;

  @override
  final PriceIndicationMode priceIndicationMode;

  @override
  final bool showAddLinkButton;

  @override
  final bool successSave;

  @override
  final (bool, String?) error;
}
