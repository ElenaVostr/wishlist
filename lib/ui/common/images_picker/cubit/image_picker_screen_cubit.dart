import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'image_picker_screen_state.dart';

class ImagePickerScreenCubit extends Cubit<ImagePickerScreenState> {
  final ImagePicker _picker = ImagePicker();

  ImagePickerScreenCubit() : super(const ImagesLoadedState(imagesList: []));

  void openGallery() {
    _getImagesFromGallery();
  }

  void openCamera() {
    _getImageFromCamera();
  }

  void deleteImage(int index) {
    List<XFile> images = List.from((state as ImagesLoadedState).imagesList);
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
          imagesList: [...(state as ImagesLoadedState).imagesList, image]));
    }
  }

  Future _getImagesFromGallery() async {
    final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 50, maxWidth: 800, maxHeight: 600);
    if (images.isNotEmpty) {
      emit((state as ImagesLoadedState).copyWith(
          imagesList: [...(state as ImagesLoadedState).imagesList, ...images]));
    }
  }
}
