import 'dart:io';

import 'package:flutter/material.dart';

///Виджет возвращает иконку, если список изображение пустой. Если список содержит одно изображение, то его и отображает, а если список больше единицы, то рисует виджет с прокруткой изображение влево или вправо
class ImagesPageView extends StatelessWidget {
  final List<File> images;

  const ImagesPageView({super.key, required this.images});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      height: MediaQuery.of(context).size.width * 0.8,
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: images.isEmpty
            ? Image.asset('assets/images/image_icon.png')
            : (images.length > 1
            ? PageView(
          children: [for (File image in images) Image.file(image)],
        )
            : Image.file(images.first)),
      ),
    );
  }
}
