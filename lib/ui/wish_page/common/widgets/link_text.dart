import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/ui/wish_page/bloc/wish_page_bloc.dart';

class LinkText extends StatelessWidget {
  final String url;

  const LinkText({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishPageBloc, WishPageState>(
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(url),
                )),
            SizedBox(
              height: 32,
              width: 32,
              child: IconButton.filled(
                iconSize: 16,
                onPressed: () => BlocProvider.of<WishPageBloc>(context)
                    .add(EditLinkEvent(url: url)),
                icon: const Icon(Icons.edit),
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              height: 32,
              width: 32,
              child: IconButton.filled(
                iconSize: 16,
                onPressed: () => BlocProvider.of<WishPageBloc>(context)
                    .add(RemoveLinkEvent(url: url)),
                icon: const Icon(Icons.delete),
              ),
            ),
          ],
        );
      },
    );
  }
}