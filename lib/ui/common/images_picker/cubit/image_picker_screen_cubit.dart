import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'image_picker_screen_state.dart';

class ImagePickerScreenCubit extends Cubit<ImagePickerScreenState> {
  final ImagePicker _picker = ImagePicker();

  ImagePickerScreenCubit({required List<String> initImages}) : super(ImagePickerScreenState(imagesList: initImages));

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
    List<String> images = List.from(state.imagesList);
    images.removeAt(index);

    emit(state.copyWith(imagesList: images));
  }

  Future _getImageFromCamera() async {
    final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 800,
        maxHeight: 600);
    if (image != null) {
      emit(state.copyWith(
          imagesList: [...state.imagesList, image.path]));
    }
  }

  Future _getImagesFromGallery() async {
    final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 50, maxWidth: 800, maxHeight: 600);
    if (images.isNotEmpty) {
      List<String> imageFileList = [];
      for (var image in images) {
        imageFileList.add(image.path);
      }
      emit(state.copyWith(
          imagesList: [...state.imagesList, ...imageFileList]));
    }
  }
}
