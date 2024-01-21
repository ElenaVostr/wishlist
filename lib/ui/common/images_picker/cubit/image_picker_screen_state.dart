part of 'image_picker_screen_cubit.dart';

abstract class ImagePickerScreenState extends Equatable {
  const ImagePickerScreenState();
}

class ImagesLoadedState extends ImagePickerScreenState {
  final List<File> imagesList;

  const ImagesLoadedState({required this.imagesList});

  ImagesLoadedState copyWith({List<File>? imagesList}) {
    return ImagesLoadedState(
        imagesList: imagesList ?? this.imagesList);
  }

  @override
  List<Object?> get props => [imagesList];
}
