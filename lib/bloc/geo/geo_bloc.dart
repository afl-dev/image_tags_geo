import 'package:bloc/bloc.dart';
import 'package:image_tags_geo/models/image_tags_geo_model.dart';
import 'package:image_tags_geo/service/image_tags_geo_service.dart';
import 'package:location/location.dart';

part 'geo_event.dart';

part 'geo_state.dart';

class GeoBloc extends Bloc<GeoEvent, GeoState> {
  final ImageTagsGeoService imageTagsGeoService;

  // final ImageTagsGeoModel imageTagsGeoData;
  LocationData location;
  String latitude;
  String longitude;

  GeoBloc(
      {this.latitude,
      this.longitude,
      // this.imageTagsGeoData,
      this.location,
      this.imageTagsGeoService});

  @override
  GeoState get initialState => InitialGeoState();

  @override
  Stream<GeoState> mapEventToState(GeoEvent event) async* {
    if (event is UpdateGpsEvent) {
      yield DataGpsUpdating();
      yield* _gpsChangedStateSave(event);
    }

    if (event is CleanDataGpsEvent) {
      yield DataGpsUpdated(
          latitude: latitude = null, longitude: longitude = null);
    }
  }

  Stream<GeoState> _gpsChangedStateSave(event) async* {
    try {
      location = await imageTagsGeoService.getCurrentUserLocation
          .timeout(const Duration(seconds: 5));
      latitude = location.latitude.toStringAsFixed(6);
      longitude = location.longitude.toStringAsFixed(6);

      try {
        await imageTagsGeoService.saveShared('latitude', latitude);
        await imageTagsGeoService.saveShared('longitude', longitude);
      } catch (error) {
        yield DataGpsUpdatingError(error: error.toString());
        throw (error);
      }
      yield DataGpsUpdated(latitude: latitude, longitude: longitude);
    } catch (error) {
      print(error.toString());
      yield DataGpsUpdatingError(error: error.toString());
      //throw (error);
    }
  }

/*  Stream<GeoState> _gpsChangedStateGet(event) async* {
    latitude = await imageTagsGeoService.getShared('latitude');
    longitude = await imageTagsGeoService.getShared('longitude');
    yield DataGpsUpdated(latitude: latitude, longitude: longitude);
  }*/
}
