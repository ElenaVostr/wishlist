import 'package:wishlist/domain/models/wish.dart';

abstract class WishRepository {
  Future<void> createWish(Wish wish);

  Future<void> replaceWish(Wish wish, {List<String>? imagesForDelete, bool updateImages = false});

  Future<void> deleteWish(String uid);

  Stream<List<Wish>> getWishListStream();

  Stream<Wish> getWishByUid(String uid);

}