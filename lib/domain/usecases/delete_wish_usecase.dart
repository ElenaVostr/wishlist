import 'package:wishlist/domain/repositories/wish_repository.dart';

class DeleteWishUseCase {

  final WishRepository _wishRepository;

  DeleteWishUseCase({required WishRepository wishRepository}) : _wishRepository = wishRepository;

  Future<void> run(int uid) {
    return _wishRepository.deleteWish(uid);
  }
}