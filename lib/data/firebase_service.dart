import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  late final FirebaseApp app;
  late final FirebaseFirestore firestore;

  static FirebaseService? _instance;

  FirebaseService._();

  factory FirebaseService() {
    if (_instance != null) {
      return _instance!;
    }
    _instance = FirebaseService._();
    return _instance!;
  }

  Future<void> init() async{

    app = await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyA8qA4qGCToiEZCvw-ZwVQG0ZbaoGGBR1s',
        appId: '1:631325131862:android:bb14ff2f737c9c3272e7f7',
        messagingSenderId: '631325131862',
        projectId: 'wishlist-5bf25',
      ),
    );

    firestore = FirebaseFirestore.instance;
  }
}