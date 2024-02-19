import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/domain/models/wish.dart';
import 'package:wishlist/ui/common/widgets/text_link.dart';
import 'package:wishlist/ui/common/widgets/widget_with_title.dart';
import 'package:wishlist/ui/wish_page/bloc/wish_page_bloc.dart';
import 'package:wishlist/ui/wish_page/common/widgets/images_page_view.dart';

class BodyViewMode extends StatelessWidget {
  const BodyViewMode({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WishPageBloc, WishPageState>(
      builder: (context, state) {
        Wish? wish = (state as ViewWishState).wish;
        return wish != null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ImagesPageView(images: wish.images),
                  WidgetWithTitle(
                      child: Text(wish.name,
                          style: const TextStyle(fontSize: 16))),
                  wish.description.isNotEmpty
                      ? WidgetWithTitle(
                          title: 'Описание',
                          child: Text(wish.description,
                              style: const TextStyle(fontSize: 16)),
                        )
                      : const SizedBox(),
                  wish.urls.isNotEmpty
                      ? WidgetWithTitle(
                          title: 'Ссылки',
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (final item in wish.urls)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            child: TextLink(
                                                text: item, url: item)),
                                        GestureDetector(
                                            onTap: () async {
                                              await Clipboard.setData(
                                                      ClipboardData(text: item))
                                                  .then((_) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Ссылка скопирована")));
                                              });
                                            },
                                            child: const Icon(
                                              Icons.copy,
                                              color: Colors.black54,
                                              size: 20,
                                            ))
                                      ],
                                    ),
                                    const Divider(
                                        height: 12,
                                        thickness: 1,
                                        color: Colors.black12),
                                  ],
                                )
                            ],
                          ),
                        )
                      : const SizedBox(),
                  wish.price != null
                      ? WidgetWithTitle(
                          title: 'Цена',
                          child: Row(
                            children: [
                              wish.price!.$2 != null
                                  ? const Text(
                                      'от ',
                                      style: TextStyle(color: Colors.black54),
                                    )
                                  : const SizedBox(),
                              Text('${wish.price!.$1}'),
                              const SizedBox(width: 32),
                              wish.price!.$2 != null
                                  ? const Text(
                                      'до ',
                                      style: TextStyle(color: Colors.black54),
                                    )
                                  : const SizedBox(),
                              wish.price!.$2 != null
                                  ? Text('${wish.price!.$2}')
                                  : const SizedBox(),
                            ],
                          ))
                      : const SizedBox(),
                  const SizedBox(height: 24)
                ],
              )
            : Text((state.errorMessage ?? 'Ошибка загрузки желания'));
      },
    );
  }
}
