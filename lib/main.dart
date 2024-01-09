import 'package:flutter/material.dart';
import 'package:wishlist/di/di.dart';
import 'package:wishlist/domain/models/wish.dart';
import 'package:wishlist/ui/main_page_wish_list/main_page_wish_list.dart';

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
      home: const MainPageWishList(),
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
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.grey,
              height: MediaQuery.of(context).size.width * 0.8,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: widget.wish.images.isNotEmpty
                    ? Image.network(widget.wish.images.first)
                    : Image.asset('assets/images/image_icon.png'),
              ),
            ),
            // Container(
            //   height: 250,
            //   decoration: BoxDecoration(
            //       color: Colors.grey,
            //       image: DecorationImage(
            //         fit: BoxFit.contain,
            //         image: (widget.wish.images.isNotEmpty
            //                 ? NetworkImage(widget.wish.images.first)
            //                 : const AssetImage('assets/images/image_icon.png'))
            //             as ImageProvider,
            //       )),
            // ),
            const SizedBox(height: 16),
            Text(widget.wish.name, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Text(widget.wish.description),
            const SizedBox(height: 16),
            widget.wish.price != null
                ? Row(
                    children: [
                      Text('${widget.wish.price!.$1}'),
                      const SizedBox(width: 32),
                      widget.wish.price!.$2 != null
                          ? Text('${widget.wish.price!.$2}')
                          : const SizedBox(),
                    ],
                  )
                : const Text('no price')
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
