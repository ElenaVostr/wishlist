import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/ui/wish_page/bloc/wish_page_bloc.dart';

class LinkFormField extends StatelessWidget {
  const LinkFormField({super.key});

  @override
  Widget build(BuildContext context) {
    WishPageBloc wishPageBloc = BlocProvider.of<WishPageBloc>(context);
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: wishPageBloc.fieldLinkController,
            focusNode: wishPageBloc.linkFieldFocusNode,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              filled: true,
              contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
              hintText: 'Введите ссылку',
              fillColor: Colors.black12,
              border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        IconButton.filled(
          iconSize: 24,
          onPressed: () =>
              BlocProvider.of<WishPageBloc>(context).add(const SaveLinkEvent()),
          icon: const Icon(Icons.add),
        )
      ],
    );
  }
}