import 'package:bloc/bloc.dart';

part 'tag_vol_event.dart';

part 'tag_vol_state.dart';

class TagVolBloc extends Bloc<TagVolEvent, TagVolState> {
  bool tagA;
  bool tagB;
  bool tagC;
  double slide;

  TagVolBloc(
      {this.tagA = false,
      this.tagB = false,
      this.tagC = false,
      this.slide = 0});

  @override
  TagVolState get initialState =>
      TagVolStateInitial(tagA: tagA, tagB: tagB, tagC: tagC, slide: slide);

  @override
  Stream<TagVolState> mapEventToState(TagVolEvent event) async* {
    if (event is UpdateTagVolEvent) {
      tagA = event.tagA;
      tagB = event.tagB;
      tagC = event.tagC;
      yield TagUpdatedTagVolState(
          tagA: tagA, tagB: tagB, tagC: tagC, slide: slide);
    }

    if (event is UpdateSlideTagVolEvent) {
      slide = event.slide;
      yield TagUpdatedTagVolState(
          tagA: tagA, tagB: tagB, tagC: tagC, slide: slide);
    }

    if (event is CleanDataTagVolEven) {
      yield TagVolStateInitial(
          tagA: tagA = false,
          tagB: tagB = false,
          tagC: tagC = false,
          slide: slide = 0);
    }
  }
}
