import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/domain/models/wish.dart';
import 'package:wishlist/ui/wish_page/bloc/wish_page_bloc.dart';
import 'package:wishlist/ui/wish_page/common/widgets/add_link.dart';
import 'package:wishlist/ui/wish_page/common/widgets/link_form_fields.dart';
import 'package:wishlist/ui/wish_page/common/widgets/link_text.dart';

class LinksView extends StatelessWidget {
  const LinksView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishPageBloc, WishPageState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (Link link in (state as WishEditable).urls) LinkText(url: link),
            state.showAddLinkButton ? const AddLink() : const LinkFormField(),
          ],
        );
      },
    );
  }
}