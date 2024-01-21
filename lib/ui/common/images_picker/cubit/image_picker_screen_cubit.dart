import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'image_picker_screen_state.dart';

class ImagePickerScreenCubit extends Cubit<ImagePickerScreenState> {
  final ImagePicker _picker = ImagePicker();

  ImagePickerScreenCubit({required List<File> initImages}) : super(ImagesLoadedState(imagesList: initImages));

  /// Открыть галерею
  void openGallery() {
    _getImagesFromGallery();
  }

  /// Открыть камеру
  void openCamera() {
    _getImageFromCamera();
  }

  /// Удалить изображение
  void deleteImage(int index) {
    List<File> images = List.from((state as ImagesLoadedState).imagesList);
    images.removeAt(index);

    emit((state as ImagesLoadedState).copyWith(imagesList: images));
  }

  Future _getImageFromCamera() async {
    final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 800,
        maxHeight: 600);
    if (image != null) {
      emit((state as ImagesLoadedState).copyWith(
          imagesList: [...(state as ImagesLoadedState).imagesList, File(image.path)]));
    }
  }

  Future _getImagesFromGallery() async {
    final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 50, maxWidth: 800, maxHeight: 600);
    if (images.isNotEmpty) {
      List<File> imageFileList = [];
      for (var image in images) {
        imageFileList.add(File(image.path));
      }
      emit((state as ImagesLoadedState).copyWith(
          imagesList: [...(state as ImagesLoadedState).imagesList, ...imageFileList]));
    }
  }
}
