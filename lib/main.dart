import 'package:flutter/material.dart';
import 'package:wishlist/di/di.dart';
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
