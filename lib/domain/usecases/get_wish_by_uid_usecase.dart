import 'package:wishlist/domain/models/wish.dart';
import 'package:wishlist/domain/repositories/wish_repository.dart';

class GetWishByUidUseCase {
  final WishRepository _wishRepository;

  GetWishByUidUseCase({required WishRepository wishRepository}) : _wishRepository = wishRepository;

  Stream<Wish> run({required String uid}) {
    return _wishRepository.getWishByUid(uid);
  }
}