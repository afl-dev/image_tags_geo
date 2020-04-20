part of 'image_bloc.dart';

abstract class ImageState {
  const ImageState();

// List<Object> get props => [];
}

class InitialImageState extends ImageState {}


class UpdatingImageState extends ImageState {}

class UpdatedImageState extends ImageState {
  final File storedImage;

  UpdatedImageState({this.storedImage});
}