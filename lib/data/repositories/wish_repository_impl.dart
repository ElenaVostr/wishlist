import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:wishlist/common/utils/url_util.dart';
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
    return loadImages(images: wish.images, docId: docRef.id);
  }

  Future<void> loadImages({required List<String> images, required String docId}) async {
    if(images.isNotEmpty){
      List<String> imageList = [];
      for(String image in images){
        if(image.contains('https://', 0) || image.contains('http://', 0)){
          imageList.add(image);
        } else {
          File imageFile = File(image);
          String? imageUrl = await uploadImageInStorage(imageFile: imageFile, uid: docId, fileName: basenameWithoutExtension(image));
          if(imageUrl != null){
            imageList.add(imageUrl);
          }
        }
      }
      return firebaseService.firestore.collection('wishes').doc(docId).update(
          {'images': imageList});
    }
    return;
  }

  @override
  Future<void> deleteWish(String uid) async {
    await deleteAllImages(uid);
    return firebaseService.firestore.collection('wishes').doc(uid).delete();
  }

  Future<void> deleteAllImages(String uid) {
    return firebaseService.storage.ref('images/$uid').listAll().then((value) {
      for (var element in value.items) {
        firebaseService.storage.ref(element.fullPath).delete();
      }});
  }

  Future<void> deleteImageFromStorage(String uid, String fileName) {
    return firebaseService.storage.ref('images/$uid/$fileName').delete();
  }

  @override
  Future<void> replaceWish(Wish wish, {List<String>? imagesForDelete, bool updateImages = false}) async {
    firebaseService.firestore
        .collection('wishes')
        .doc(wish.uid)
        .update(WishDoc.fromWish(wish, firebaseService.storage, wish.uid).toJson());
    if(imagesForDelete != null && imagesForDelete.isNotEmpty){
      for(String filePath in imagesForDelete){
        await deleteImageFromStorage(wish.uid!, UrlUtil.getFileNameFromUrl(filePath));
      }
    }
    if(updateImages){
      await loadImages(images: wish.images, docId: wish.uid!);
    }
    return;
  }

  @override
  Stream<List<Wish>> getWishListStream() {
    return firebaseService.firestore.collection('wishes').snapshots().map(
        (event) =>
            event.docs.map((e) => WishDoc.fromJson(e.data()).toWish(e.id)).toList());
  }

  Future<String?> uploadImageInStorage(
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
