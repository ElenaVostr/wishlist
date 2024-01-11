import 'package:wishlist/domain/models/wish.dart';
import 'package:wishlist/domain/repositories/wish_repository.dart';

class GetWishListStreamUseCase {
  final WishRepository _wishRepository;

  GetWishListStreamUseCase({required WishRepository wishRepository}) : _wishRepository = wishRepository;

  Stream<List<Wish>> run() {
    return _wishRepository.getWishListStream();
  }
}