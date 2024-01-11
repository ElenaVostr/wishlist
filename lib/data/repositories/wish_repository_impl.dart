import 'package:wishlist/data/firebase_service.dart';
import 'package:wishlist/domain/models/wish.dart';
import 'package:wishlist/domain/repositories/wish_repository.dart';

class WishRepositoryImpl implements WishRepository {
  final FirebaseService firebaseService;

  const WishRepositoryImpl({required this.firebaseService});

  @override
  Future<void> createWish(Wish wish) {
    return firebaseService.firestore.collection('wishes').add(wish.toJson());
  }

  @override
  Future<void> deleteWish(String uid) {
    return firebaseService.firestore.collection('wishes').doc(uid).delete();
  }

  @override
  Future<void> replaceWish(Wish wish) {
    return firebaseService.firestore
        .collection('wishes')
        .doc(wish.uid)
        .update(wish.toJson());
  }

  @override
  Stream<List<Wish>> getWishListStream() {
    return firebaseService.firestore
        .collection('wishes')
        .withConverter<Wish>(
            fromFirestore: (snapshot, _) =>
                Wish.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (wish, _) => wish.toJson())
        .snapshots()
        .map((event) => event.docs.map((e) => e.data()).toList());
  }
}
