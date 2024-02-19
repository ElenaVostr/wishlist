import 'package:wishlist/domain/enums/wish_status.dart';
import 'package:wishlist/domain/models/wish.dart';
import 'package:wishlist/domain/repositories/wish_repository.dart';

class EditWishUseCase {
  final WishRepository _wishRepository;

  EditWishUseCase({required WishRepository wishRepository})
      : _wishRepository = wishRepository;

  Future<void> run(
    Wish oldWish, {
    String? name,
    String? description,
    WishStatus? status,
    List<Link>? urls,
    List<Link>? images,
    String? list,
    (double, double?)? price,
    bool resetPrice = false,
  }) {
    List<String> imagesForDelete = [];
    List<String> imagesForSet = [];
    if (images != null) {
      imagesForDelete =
          oldWish.images.where((element) => !images.contains(element)).toList();
      imagesForSet =
          images.where((element) => !oldWish.images.contains(element)).toList();
    }

    return _wishRepository.replaceWish(
        Wish(
          uid: oldWish.uid,
          name: name ?? oldWish.name,
          description: description ?? oldWish.description,
          status: status ?? oldWish.status,
          urls: urls ?? oldWish.urls,
          images: images ?? oldWish.images,
          list: list ?? oldWish.list,
          price: price ?? (resetPrice ? null : oldWish.price),
        ),
        imagesForDelete: imagesForDelete,
        updateImages: imagesForSet.isNotEmpty || imagesForDelete.isNotEmpty);
  }
}
