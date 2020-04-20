part of 'main_bloc.dart';

abstract class MainEvent {
  const MainEvent();
}

class AppStartMainEvent extends MainEvent {}

class ResumedAppMainEvent extends MainEvent {}

class PostRequestMainEvent extends MainEvent {
  final ImageTagsGeoModel imageTagsGeoModel;

  PostRequestMainEvent({this.imageTagsGeoModel});
}

class PostRequestErrorMainEvent extends MainEvent {}
