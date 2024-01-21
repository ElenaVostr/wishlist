import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/di/di.dart';
import 'package:wishlist/domain/usecases/create_wish_usecase.dart';
import 'package:wishlist/domain/usecases/get_wish_list_stream_usecase.dart';
import 'package:wishlist/ui/common/enums/wish_page_type.dart';
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
                          child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          crossAxisCount: 2,
                        ),
                        itemCount: state.wishList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return WishPage(
                                  wish: state.wishList[index],
                                  wishPageType: WishPageType.view);
                            })),
                            child: Card(
                              elevation: 8,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: (state.wishList[index]
                                                          .imagePreview !=
                                                      null
                                                  ? MemoryImage(
                                                      Uint8List.fromList(
                                                          state
                                                              .wishList[index]
                                                              .imagePreview!
                                                              .codeUnits))
                                                  : const AssetImage(
                                                      'assets/images/image_icon.png'))
                                              as ImageProvider,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 32,
                                    child: Center(
                                      child: Text(
                                        state.wishList[index].name,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 12, height: 0.8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ))
                    ],
                  ),
                );
              } else {
                return const SizedBox();
              }
            }),
            floatingActionButton: FloatingActionButton(
              //onPressed: () => BlocProvider.of<MainPageWishListBloc>(context).add(const CreateWishEvent()),
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (BuildContext context) {
                return const WishPage(wishPageType: WishPageType.create);
              })),
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
