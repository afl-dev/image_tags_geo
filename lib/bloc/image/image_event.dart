part of 'image_bloc.dart';

abstract class ImageEvent {}

class UpdatingImageEvent extends ImageEvent {
  final File storedImage;

  UpdatingImageEvent({this.storedImage});
}

class UpdatedImageEvent extends ImageEvent {}

class InitialImageEvent extends ImageEvent {}

class CleanDataImageEvent extends ImageEvent {}
