import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  late final FirebaseApp app;
  late final FirebaseFirestore firestore;
  late final FirebaseStorage storage;

  Future<void> init() async{

    app = await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyA8qA4qGCToiEZCvw-ZwVQG0ZbaoGGBR1s',
        appId: '1:631325131862:android:bb14ff2f737c9c3272e7f7',
        messagingSenderId: '631325131862',
        projectId: 'wishlist-5bf25',
        storageBucket: 'wishlist-5bf25.appspot.com'
      ),
    );

    firestore = FirebaseFirestore.instance;
    storage = FirebaseStorage.instance;
  }
}