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
  final List<Link> images;
  final String? imagePreview;
  final String list;
  final (double, double?)? price;

  const Wish({
    this.uid,
    required this.name,
    this.description = '',
    this.status = WishStatus.undone,
    this.urls = const <Link>[],
    this.images = const <Link>[],
    this.imagePreview,
    this.list = '',
    this.price,
  });

}

