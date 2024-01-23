import 'package:flutter/material.dart';
import 'package:wishlist/domain/models/wish.dart';
import 'package:wishlist/ui/common/enums/wish_page_type.dart';
import 'package:wishlist/ui/wish_page/wish_page.dart';

class AppBarViewMode extends AppBar {
  AppBarViewMode({super.key, required BuildContext context, Wish? initWish}):super(
    title: const Text("Просмотр желания"),
    actions: [
      IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return WishPage(key: UniqueKey(), wishPageType: WishPageType.edit, wish: initWish);
        })),
      ),
      IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => null,
      ),
    ],
  );
}