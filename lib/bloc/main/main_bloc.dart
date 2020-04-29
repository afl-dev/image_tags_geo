import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:image_tags_geo/models/image_tags_geo_model.dart';
import 'package:image_tags_geo/service/image_tags_geo_service.dart';
import 'package:image_tags_geo/validators.dart';

part 'main_event.dart';

part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  final ImageTagsGeoService imageTagsGeoService;
  bool isValidGps;
  bool isValidImage;

  MainBloc(
      {this.isValidGps = false,
      this.isValidImage = false,
      this.imageTagsGeoService});

  @override
  MainState get initialState => InitialMainState();

  @override
  Stream<MainState> mapEventToState(MainEvent event) async* {
    if (event is ResumedAppMainEvent) {
      yield ResumedMainState();
    }

    if (event is PostRequestMainEvent) {
      if (Validators.isValid(event.imageTagsGeoModel.latitude) &&
          Validators.isValid(event.imageTagsGeoModel.longitude)) {
        isValidGps = true;
      } else {
        isValidGps = false;
      }
      if (Validators.isValid(event.imageTagsGeoModel.image)) {
        event.imageTagsGeoModel.imag64 =
            base64Encode((event.imageTagsGeoModel.image)?.readAsBytesSync());
        isValidImage = true;
      } else {
        isValidImage = false;
      }
      if (isValidGps && isValidImage) {
        yield PostUpdatingMainState();
        bool response =
            await imageTagsGeoService.postRequest(event.imageTagsGeoModel);
        if (response) {
          yield PostUpdatedMainState();
          yield InitialMainState();
        } else {
          print('PostError()');
          yield PostErrorMainState();
          yield InitialMainState();
        }
      } else {
        yield EmptyDataInputMainState(
            isValidGps: isValidGps, isValidImage: isValidImage);
        yield InitialMainState();
      }
    }
  }
}
