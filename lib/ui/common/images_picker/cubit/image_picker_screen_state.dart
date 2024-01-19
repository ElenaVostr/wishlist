part of 'image_picker_screen_cubit.dart';

abstract class ImagePickerScreenState extends Equatable {
  const ImagePickerScreenState();
}

class ImagesLoadedState extends ImagePickerScreenState {
  final List<XFile> imagesList;

  const ImagesLoadedState({required this.imagesList});

  ImagesLoadedState copyWith({List<XFile>? imagesList}) {
    return ImagesLoadedState(
        imagesList: imagesList ?? this.imagesList);
  }

  @override
  List<Object?> get props => [imagesList];
}
