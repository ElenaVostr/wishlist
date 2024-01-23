import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:wishlist/data/firebase_service.dart';
import 'package:wishlist/data/models/wish_doc.dart';
import 'package:wishlist/domain/models/wish.dart';
import 'package:wishlist/domain/repositories/wish_repository.dart';

class WishRepositoryImpl implements WishRepository {
  final FirebaseService firebaseService;

  const WishRepositoryImpl({required this.firebaseService});

  @override
  Future<void> createWish(Wish wish) async {
    DocumentReference docRef = await firebaseService.firestore.collection('wishes').add(WishDoc.fromNewWish(wish).toJson());
    if(wish.images.isNotEmpty){
      String docId = docRef.id;
      List<String> imageList = [];
      for(String image in wish.images){
        File imageFile = File(image);
        String? imageUrl = await uploadImage(imageFile: imageFile, uid: docId, fileName: basenameWithoutExtension(image));
        if(imageUrl != null){
          imageList.add(imageUrl);
        }
      }
      return firebaseService.firestore.collection('wishes').doc(docId).update(
          {'images': imageList});
    }
    return;
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

  Future<String?> uploadImage(
      {required File imageFile, required String uid, required String fileName}) async {
    try {
      var uploadTask = await firebaseService.storage.ref('images/$uid').child(fileName).putFile(imageFile, SettableMetadata(contentType:'image/jpeg'));
      return await uploadTask.ref.getDownloadURL();
    } catch (error, stack) {
      return null;
    }
  }

  @override
  Stream<Wish> getWishByUid(String uid) {
    return firebaseService.firestore.collection('wishes').doc(uid).snapshots().map((snapshot) {
      return WishDoc.fromJson(snapshot.data()!).toWish(uid);
    });
  }
}
