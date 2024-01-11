import 'package:wishlist/domain/models/wish.dart';

abstract class WishRepository {
  Future<void> createWish(Wish wish);

  Future<void> replaceWish(Wish wish);

  Future<void> deleteWish(String uid);

  Stream<List<Wish>> getWishListStream();

}