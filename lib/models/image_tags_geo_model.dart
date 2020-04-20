import 'dart:io';

class ImageTagsGeoModel {
  File image;
  String latitude;
  String longitude;
  int id;
  DateTime dateTime;
  String imag64;
  bool tagA;
  bool tagB;
  bool tagC;
  double slide;

  ImageTagsGeoModel(
      {this.image,
      this.latitude,
      this.longitude,
      this.id,
      this.dateTime,
      this.imag64,
      this.tagA,
      this.tagB,
      this.tagC,
      this.slide});

  List<Object> get props =>
      [latitude, longitude, id, dateTime, imag64, tagA, tagB, tagC, slide];
}
