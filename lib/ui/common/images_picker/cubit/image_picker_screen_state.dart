part of 'image_picker_screen_cubit.dart';

class ImagePickerScreenState with EquatableMixin {
  final List<String> imagesList;

  const ImagePickerScreenState({required this.imagesList});

  ImagePickerScreenState copyWith({List<String>? imagesList}) {
    return ImagePickerScreenState(
        imagesList: imagesList ?? this.imagesList);
  }

  @override
  List<Object?> get props => [imagesList];
}
