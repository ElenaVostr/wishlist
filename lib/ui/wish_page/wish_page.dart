import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/di/di.dart';
import 'package:wishlist/domain/models/wish.dart';
import 'package:wishlist/domain/usecases/create_wish_usecase.dart';
import 'package:wishlist/ui/common/enums/wish_page_type.dart';
import 'package:wishlist/ui/wish_page/app_bar/app_bar_create_mode.dart';
import 'package:wishlist/ui/wish_page/app_bar/app_bar_edit_mode.dart';
import 'package:wishlist/ui/wish_page/app_bar/app_bar_view_mode.dart';
import 'package:wishlist/ui/wish_page/bloc/wish_page_bloc.dart';
import 'package:wishlist/ui/wish_page/body/body_create_mode.dart';
import 'package:wishlist/ui/wish_page/body/body_edit_mode.dart';
import 'package:wishlist/ui/wish_page/body/body_view_mode.dart';

class WishPage extends StatelessWidget {
  const WishPage({super.key, this.wish, required this.wishPageType});

  final Wish? wish;
  final WishPageType wishPageType;

  AppBar _getAppBar(WishPageState state) {
    if (state is ViewWishState) {
      return AppBarViewMode();
    } else if (state is EditWishState) {
      return AppBarEditMode();
    }
    return AppBarCreateMode();
  }

  Widget _getBody(WishPageState state) {
    if (state is ViewWishState) {
      return const BodyViewMode();
    } else if (state is EditWishState) {
      return const BodyEditMode();
    }
    return const BodyCreateMode();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WishPageBloc>(
      create: (context) => WishPageBloc(
          createWishUseCase: DI.getit.get<CreateWishUseCase>(),
          wishPageType: wishPageType,
          initWish: wish),
      child: Builder(
        builder: (context) {
          return BlocListener<WishPageBloc, WishPageState>(
            listener: (context, state){
              if(state is WishEditable && state.successSave){
                Navigator.pop(context);
              }
            },
            child: BlocBuilder<WishPageBloc, WishPageState>(
              builder: (context, state) {
                return Scaffold(
                  appBar: _getAppBar(state),
                  body: SingleChildScrollView(
                    controller: BlocProvider.of<WishPageBloc>(context).scrollController,
                    child: _getBody(state),
                  ),
                  floatingActionButton: (state is ViewWishState)
                      ? FloatingActionButton(
                    onPressed: () => null,
                    tooltip: 'Желание исполнено',
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    child: const Icon(Icons.done_rounded),
                  )
                      : const SizedBox(), //// This trailing comma makes auto-formatting nicer for build methods.
                );
              },
            ),
          );
        },
      ),
    );
  }
}
