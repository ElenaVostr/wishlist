import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wishlist/data/firebase_service.dart';
import 'package:wishlist/data/repositories/wish_repository_impl.dart';
import 'package:wishlist/domain/models/wish.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseService firebaseService = FirebaseService();
  await firebaseService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CollectionReference<Wish> _wishesRef;
  late FirebaseService _firebaseService;

  @override
  void initState() {
    super.initState();

    _firebaseService = FirebaseService();

    _wishesRef = _firebaseService.firestore
        .collection('wishes')
        .withConverter<Wish>(
            fromFirestore: (snapshot, _) => Wish.fromJson(snapshot.data()!, snapshot.id),
            toFirestore: (wish, _) => wish.toJson());
  }

  Future<void> _createWish() async {
    WishRepositoryImpl wishRepositoryImpl = WishRepositoryImpl(firebaseService: _firebaseService);
    wishRepositoryImpl.createWish(const Wish(name: 'новое желание'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: StreamBuilder<List<Wish>>(
              stream: _wishesRef
                  .snapshots()
                  .map((event) => event.docs.map((e) => e.data()).toList()),
              builder: (context, snapshot) {
                return ListView(
                    children: snapshot.hasData
                        ? snapshot.data!
                        .map((e) => ListTile(
                        leading: Text(e.name),
                        trailing: Text(e.description)))
                        .toList()
                        : []);
              },
            ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createWish,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), //// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
