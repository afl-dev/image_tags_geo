part of 'tag_vol_bloc.dart';

abstract class TagVolState {
  const TagVolState();
}

class TagVolStateInitial extends TagVolState {
  final bool tagA;
  final bool tagB;
  final bool tagC;
  final double slide;

  TagVolStateInitial({this.slide, this.tagA, this.tagB, this.tagC});
}

class TagUpdatedTagVolState extends TagVolState {
  final bool tagA;
  final bool tagB;
  final bool tagC;
  final double slide;

  TagUpdatedTagVolState({this.slide, this.tagA, this.tagB, this.tagC});
}
