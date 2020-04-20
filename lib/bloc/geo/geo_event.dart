part of 'geo_bloc.dart';

abstract class GeoEvent {
  const GeoEvent();
}

class UpdateGpsEvent extends GeoEvent {}

class UpdateGpsEventLifecycles extends GeoEvent {}

class CleanDataGpsEvent extends GeoEvent {}
