import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/ui/wish_page/bloc/wish_page_bloc.dart';

class AddLink extends StatelessWidget {
  const AddLink({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => BlocProvider.of<WishPageBloc>(context)
            .add(const AddNewLinkTextFieldEvent()),
        child: const Text('Добавить новую ссылку'));
  }
}