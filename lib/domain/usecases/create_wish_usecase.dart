import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:wishlist/domain/models/wish.dart';
import 'package:wishlist/domain/repositories/wish_repository.dart';

class CreateWishUseCase {

  final WishRepository _wishRepository;

  CreateWishUseCase({required WishRepository wishRepository}) : _wishRepository = wishRepository;

  Future<void> run(Wish wish) async {
    return _wishRepository.createWish(wish);
  }
}
