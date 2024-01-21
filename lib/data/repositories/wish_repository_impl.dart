import 'dart:io';

import 'package:wishlist/data/firebase_service.dart';
import 'package:wishlist/data/models/wish_doc.dart';
import 'package:wishlist/domain/models/wish.dart';
import 'package:wishlist/domain/repositories/wish_repository.dart';

class WishRepositoryImpl implements WishRepository {
  final FirebaseService firebaseService;

  const WishRepositoryImpl({required this.firebaseService});

  @override
  Future<void> createWish(Wish wish) {
    return firebaseService.firestore.collection('wishes').add(WishDoc.fromNewWish(wish).toJson());
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
        .update(WishDoc.fromWish(wish, firebaseService.storage, wish.uid).toJson());
  }

  @override
  Stream<List<Wish>> getWishListStream() {
    return firebaseService.firestore.collection('wishes').snapshots().map(
        (event) =>
            event.docs.map((e) => WishDoc.fromJson(e.data()).toWish(e.id)).toList());
  }

  Future<String> uploadImage(
      {required File imageFile, required String uid, required String fileName}) async {
    String downloadUrl = await firebaseService.storage.ref('images/$uid').child(fileName).putFile(imageFile).snapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}
