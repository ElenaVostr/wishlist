import 'package:wishlist/domain/enums/wish_status.dart';

typedef Id = int;
typedef Link = String;

/// Модель данных для желания
class Wish {
  final int uid;
  final String name;
  final String description;
  final WishStatus status;
  final List<Link> urls;
  final List<Link> images;
  final List<Id> lists;
  final (double, double?)? price;

  const Wish({
    this.uid = -1,
    required this.name,
    this.description = '',
    this.status = WishStatus.undone,
    this.urls = const <Link>[],
    this.images = const <Link>[],
    this.lists = const <Id>[],
    this.price,
  });
}
