part of 'tag_vol_bloc.dart';

abstract class TagVolEvent {
  const TagVolEvent();
}

class UpdateTagVolEvent extends TagVolEvent {
  final bool tagA;
  final bool tagB;
  final bool tagC;

  UpdateTagVolEvent({this.tagA, this.tagB, this.tagC});
}

class UpdateSlideTagVolEvent extends TagVolEvent {
  final double slide;

  UpdateSlideTagVolEvent({this.slide});
}

class CleanDataTagVolEven extends TagVolEvent {}
