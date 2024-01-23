import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/domain/models/wish.dart';
import 'package:wishlist/ui/common/enums/wish_page_type.dart';
import 'package:wishlist/ui/wish_page/bloc/wish_page_bloc.dart';
import 'package:wishlist/ui/wish_page/wish_page.dart';

class AppBarViewMode extends AppBar {
  AppBarViewMode({super.key, required BuildContext context})
      : super(
          title: const Text("Просмотр желания"),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context1) {
                return WishPage(
                    wishPageType: WishPageType.edit,
                    wish: (BlocProvider.of<WishPageBloc>(context).state
                            as ViewWishState)
                        .wish);
              })),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => BlocProvider.of<WishPageBloc>(context)
                  .add(const DeleteWishEvent()),
            ),
          ],
        );
}
