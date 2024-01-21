import 'dart:io';

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
  final List<File> images;
  final String? imagePreview;
  final String list;
  final (double, double?)? price;

  const Wish({
    this.uid,
    required this.name,
    this.description = '',
    this.status = WishStatus.undone,
    this.urls = const <Link>[],
    this.images = const <File>[],
    this.imagePreview,
    this.list = '',
    this.price,
  });

  // factory Wish.fromJson(Map<String, dynamic> json, String uid) {
  //   return Wish(
  //     uid: uid,
  //     name: JsonExt.getString(json['name']) ?? '',
  //     description: JsonExt.getString(json['description']) ?? '',
  //     status: JsonExt.getEnum<WishStatus>(json['status'], values: WishStatus.values) ?? WishStatus.undone,
  //     urls: JsonExt.getList<Link>(json['urls'], converter: (e) => e),
  //     //images: (json['images'] as List<dynamic>?)?.cast<Link>().toList() ?? const <Link>[],
  //     images: const <File>[],
  //     lists: (json['lists'] as List<dynamic>?)?.cast<int>() ?? const <Id>[],
  //     price: JsonExt.getPairedDouble(json['price']),
  //   );
  // }
  //
  // Map<String, dynamic> toJson() {
  //   return {
  //     'name': name,
  //     'description': description,
  //     'status': status.toName(),
  //     'urls': urls,
  //     'images': images,
  //     'lists': lists,
  //     'price': price != null ? [price!.$1, price!.$2] : null,
  //   };
  // }
}

