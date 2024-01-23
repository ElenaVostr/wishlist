import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wishlist/ui/common/image_from_path.dart';
import 'package:wishlist/ui/common/images_picker/cubit/image_picker_screen_cubit.dart';

class ImagePickerScreen extends StatelessWidget {
  final List<String> images;

  const ImagePickerScreen({super.key, this.images = const []});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ImagePickerScreenCubit>(
      create: (context) => ImagePickerScreenCubit(initImages: images),
      child: Builder(
        builder: (context) {
          return BlocBuilder<ImagePickerScreenCubit, ImagePickerScreenState>(
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: Text(
                      'Выбранные изображения ${(state as ImagesLoadedState).imagesList.length}'),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context, state.imagesList);
                    },
                  ),
                ),
                body: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => context
                                .read<ImagePickerScreenCubit>()
                                .openGallery(),
                            label: const Text('Выбрать изображения'),
                            icon: const Icon(Icons.image),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => context
                                .read<ImagePickerScreenCubit>()
                                .openCamera(),
                            label: const Text('Сделать фото'),
                            icon: const Icon(Icons.camera_alt_outlined),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 0,
                          mainAxisSpacing: 0,
                          crossAxisCount: 3,
                        ),
                        itemCount: state.imagesList.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              ImageFromPath(path: state.imagesList[index], fit: BoxFit.cover, width: double.maxFinite,),
                              Positioned(
                                right: 4,
                                top: 4,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  ),
                                  style: IconButton.styleFrom(
                                      backgroundColor: Colors.grey.withOpacity(0.2)),
                                  onPressed: () => context
                                      .read<ImagePickerScreenCubit>()
                                      .deleteImage(index),
                                ),
                              )
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
