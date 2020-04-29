part of 'image_bloc.dart';

abstract class ImageEvent {}

class UpdatingImageEvent extends ImageEvent {}

class UpdatedImageEvent extends ImageEvent {
  final File storedImage;

  UpdatedImageEvent({this.storedImage});
}

class InitialImageEvent extends ImageEvent {}

class CleanDataImageEvent extends ImageEvent {}
