import 'package:wishlist/common/utils/json_ext.dart';
import 'package:wishlist/domain/enums/wish_status.dart';

typedef Id = int;
typedef Link = String;

/// Модель данных для желания
class Wish {
  final String? uid;
  final String name;
  final String description;
  final WishStatus status;
  final List<Link> urls;
  final List<Link> images;
  final List<Id> lists;
  final (double, double?)? price;

  const Wish({
    this.uid,
    required this.name,
    this.description = '',
    this.status = WishStatus.undone,
    this.urls = const <Link>[],
    this.images = const <Link>[],
    this.lists = const <Id>[],
    this.price,
  });

  factory Wish.fromJson(Map<String, dynamic> json, String uid) {
    return Wish(
      uid: uid,
      name: JsonExt.getString(json['name']) ?? '',
      description: JsonExt.getString(json['description']) ?? '',
      status: JsonExt.getEnum<WishStatus>(json['status'], values: WishStatus.values) ?? WishStatus.undone,
      urls: JsonExt.getList<Link>(json['urls'], converter: (e) => e),
      images: (json['images'] as List<dynamic>?)?.cast<Link>().toList() ?? const <Link>[],
      lists: (json['lists'] as List<dynamic>?)?.cast<int>() ?? const <Id>[],
      price: JsonExt.getPairedDouble(json['price']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'status': status.toName(),
      'urls': urls,
      'images': images,
      'lists': lists,
      'price': price != null ? [price!.$1, price!.$2] : null,
    };
  }
}

extension WishStatusExt on WishStatus {
  String toName() {
    return name;
  }

  static WishStatus fromName(String? name) {
    if (name == null) {
      return WishStatus.undone;
    }
    return WishStatus.values
        .firstWhere((value) => value.name == name, orElse: () => WishStatus.undone);
  }
}
