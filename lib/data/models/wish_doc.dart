import 'package:wishlist/common/utils/json_ext.dart';
import 'package:wishlist/domain/enums/wish_status.dart';
import 'package:wishlist/domain/models/wish.dart';

/// Модель желания для чтения и записи в Firestore
class WishDoc {
  final String? name;
  final String? description;
  final String? status;
  final List<String>? urls;
  final List<String>? images;
  final String? list;
  final List<num>? price;

  const WishDoc({
    this.name,
    this.description,
    this.status,
    this.urls,
    this.images,
    this.list,
    this.price,
  });

  factory WishDoc.fromJson(Map<String, dynamic> json) {
    return WishDoc(
      name: JsonExt.getString(json['name']),
      description: JsonExt.getString(json['description']),
      status: JsonExt.getString(json['status']),
      urls: JsonExt.getNullableList<String>(json['urls'], converter: (e) => e),
      images:
          JsonExt.getNullableList<String>(json['images'], converter: (e) => e),
      list: JsonExt.getString(json['list']),
      price: JsonExt.getNullableList<num>(json['price'], converter: (e) => e),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'status': status,
      'urls': urls,
      'images': images,
      'list': list,
      'price': price,
    };
  }

  factory WishDoc.fromWish(Wish wish, {bool isNewWish = false}) {
    return WishDoc(
      name: wish.name,
      description: wish.description,
      status: wish.status.name,
      urls: wish.urls,
      images: isNewWish ? null : wish.images,
      list: wish.list,
      price: wish.price != null
          ? (wish.price!.$2 != null
              ? [wish.price!.$1, wish.price!.$2!]
              : [wish.price!.$1])
          : null,
    );
  }

  Wish toWish(String? uid) {
    return Wish(
        uid: uid,
        name: name ?? '',
        description: description ?? '',
        status:
            JsonExt.getEnum<WishStatus>(status, values: WishStatus.values) ??
                WishStatus.undone,
        urls: urls ?? [],
        images: images ?? [],
        list: list ?? '',
        price: JsonExt.getPairedDouble(price));
  }
}
