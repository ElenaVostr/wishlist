import 'package:flutter/material.dart';
import 'package:wishlist/di/di.dart';
import 'package:wishlist/domain/models/wish.dart';
import 'package:wishlist/domain/usecases/create_wish_usecase.dart';
import 'package:wishlist/domain/usecases/get_wish_list_stream_usecase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DI.registerDependencies();
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
      home: const MyHomePage(title: 'Wish List'),
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

  Future<void> _createWish() async {
    final useCase = DI.getit.get<CreateWishUseCase>();
    useCase.run(const Wish(name: 'новое желание'));
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
              stream: DI.getit.get<GetWishListStreamUseCase>().run(),
              builder: (context, snapshot) {
                return ListView(
                    children: snapshot.hasData
                        ? snapshot.data!
                            .map((e) => ListTile(
                                  leading: e.images.isNotEmpty
                                      ? Image.network(e.images.first,
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.fill)
                                      : Image.asset(
                                          'assets/images/image_icon.png',
                                          width: 50,
                                          height: 50,
                                          fit: BoxFit.fill),
                                  title: Text(e.name),
                                  onTap: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return WishPage(wish: e);
                                  })),
                                ))
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

class WishPage extends StatefulWidget {
  const WishPage({super.key, required this.wish});

  final Wish wish;

  @override
  State<WishPage> createState() => _WishPageState();
}

class _WishPageState extends State<WishPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        //title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.grey,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: (widget.wish.images.isNotEmpty ? NetworkImage(widget.wish.images.first) : const AssetImage('assets/images/image_icon.png')) as ImageProvider,
                )
              ),
            ),
            // widget.wish.images.isNotEmpty
            //     ? Image.network(widget.wish.images.first, height: 200, width: double.maxFinite, fit: BoxFit.fill,)
            //     : Image.asset('assets/images/image_icon.png', height: 200, width: double.maxFinite, fit: BoxFit.fill,)
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _createWish,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.add),
      // ), //// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
