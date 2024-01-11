import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/di/di.dart';
import 'package:wishlist/domain/usecases/create_wish_usecase.dart';
import 'package:wishlist/domain/usecases/get_wish_list_stream_usecase.dart';
import 'package:wishlist/ui/wish_page/wish_page.dart';

import 'bloc/main_page_wish_list_bloc.dart';

class MainPageWishList extends StatelessWidget {
  const MainPageWishList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MainPageWishListBloc>(
      create: (context) => MainPageWishListBloc(
        getWishListStreamUseCase: DI.getit.get<GetWishListStreamUseCase>(),
        createWishUseCase: DI.getit.get<CreateWishUseCase>(),
      ),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            body: BlocBuilder<MainPageWishListBloc, MainPageWishListState>(
                builder: (context, state) {
                  if (state is LoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is ErrorState) {
                    return Center(
                      child: Text(state.errorMessage),
                    );
                  } else if (state is WishListLoadedState) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              child: ListView(
                                  children: state.wishList
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
                                      .toList()))
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
            floatingActionButton: FloatingActionButton(
              onPressed: () => BlocProvider.of<MainPageWishListBloc>(context).add(const CreateWishEvent()),
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
