import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wishlist/domain/models/wish.dart';
import 'package:wishlist/ui/common/text_link.dart';
import 'package:wishlist/ui/common/widget_with_title.dart';

class WishPage extends StatefulWidget {
  const WishPage({super.key, required this.wish});

  final Wish wish;

  @override
  State<WishPage> createState() => _WishPageState();
}

Widget _drawImagesPageView(List<String> images) {
  return (images.length > 1
      ? PageView(
          children: [for (String image in images) Image.network(image)],
        )
      : Image.network(images.first));
}

class _WishPageState extends State<WishPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Просмотр желания"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => null,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => null,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              color: Colors.grey,
              height: MediaQuery.of(context).size.width * 0.8,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: widget.wish.images.isNotEmpty
                    ? _drawImagesPageView(widget.wish.images)
                    : Image.asset('assets/images/image_icon.png'),
              ),
            ),
            WidgetWithTitle(
                child: Text(widget.wish.name,
                    style: const TextStyle(fontSize: 16))),
            widget.wish.description.isNotEmpty
                ? WidgetWithTitle(
                    title: 'Описание',
                    child: Text(widget.wish.description,
                        style: const TextStyle(fontSize: 16)),
                  )
                : const SizedBox(),
            widget.wish.urls.isNotEmpty
                ? WidgetWithTitle(
                    title: 'Ссылки',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final item in widget.wish.urls)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: TextLink(text: item, url: item)),
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
            widget.wish.price != null
                ? WidgetWithTitle(
                    title: 'Цена',
                    child: Row(
                      children: [
                        widget.wish.price!.$2 != null
                            ? const Text(
                                'от ',
                                style: TextStyle(color: Colors.black54),
                              )
                            : const SizedBox(),
                        Text('${widget.wish.price!.$1}'),
                        const SizedBox(width: 32),
                        widget.wish.price!.$2 != null
                            ? const Text(
                                'до ',
                                style: TextStyle(color: Colors.black54),
                              )
                            : const SizedBox(),
                        widget.wish.price!.$2 != null
                            ? Text('${widget.wish.price!.$2}')
                            : const SizedBox(),
                      ],
                    ))
                : const SizedBox(),
            const SizedBox(height: 24)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => null,
        tooltip: 'Желание исполнено',
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: const Icon(Icons.done_rounded),
      ), //// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
