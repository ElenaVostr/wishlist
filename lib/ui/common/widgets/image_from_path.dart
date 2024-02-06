import 'dart:io';

import 'package:flutter/material.dart';

class ImageFromPath extends StatelessWidget {
  final String path;
  final BoxFit? fit;
  final double? width;
  const ImageFromPath({super.key, required this.path, this.fit, this.width});

  @override
  Widget build(BuildContext context) {
    if(path.contains('https://', 0) || path.contains('http://', 0)){
      return Image.network(path, fit: fit, width: width,);
    } else if(path.isEmpty){
      return Image.asset(
        'assets/images/image_icon.png', fit: fit, width: width);
    } else {
      return Image.file(File(path),fit: fit, width: width,);
    }
  }

}