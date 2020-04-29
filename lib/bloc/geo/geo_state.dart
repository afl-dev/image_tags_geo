part of 'geo_bloc.dart';

abstract class GeoState {
  const GeoState();

  List<Object> get props => [];
}

class InitialGeoState extends GeoState {}

class DataUpdatingState extends GeoState {}

class DataUpdatedState extends GeoState {
  final ImageTagsGeoModel imageTagsGeoModel;

  DataUpdatedState([this.imageTagsGeoModel]);

  List<Object> get props => [imageTagsGeoModel];
}

class DataGpsUpdating extends GeoState {}

class DataGpsUpdated extends GeoState {
  final String latitude;
  final String longitude;

  DataGpsUpdated({this.latitude, this.longitude});
}

class DataGpsUpdatingError extends GeoState {
  final String error;

  DataGpsUpdatingError({this.error});
}
