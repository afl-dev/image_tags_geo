part of 'main_bloc.dart';

abstract class MainState {
  const MainState();

  List<Object> get props => [];
}

class InitialMainState extends MainState {}

class UpdatingMainState extends MainState {}

class UpdatedMainState extends MainState {}

class ResumedMainState extends MainState {}

class EmptyDataInputMainState extends MainState {
  final bool isValidGps;
  final bool isValidImage;

  EmptyDataInputMainState({this.isValidGps, this.isValidImage});
}

class PostUpdatingMainState extends MainState {}

class PostUpdatedMainState extends MainState {}

class PostErrorMainState extends MainState {}
