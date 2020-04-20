import 'dart:convert';

import 'package:image_tags_geo/models/image_tags_geo_model.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ImageTagsGeoService {
  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      return locData;
    } catch (error) {
      return;
    }
  }

  Future get getCurrentUserLocation {
    return _getCurrentUserLocation();
  }

  Future<void> saveShared(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  Future<String> getShared(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(key);
    return value;
  }

  Future<bool> postRequest(ImageTagsGeoModel imageTagsGeoModel) async {
    final url = 'https://functions.yandexcloud.net/b09bhaokchn9pnbrlseb';
    final response = await http.post(
      url,
      body: json.encode({
        "bodymsg": {
          "id": imageTagsGeoModel.id,
          "timestamp": imageTagsGeoModel.dateTime.toIso8601String(),
          "lat": imageTagsGeoModel.latitude,
          "lon": imageTagsGeoModel.longitude,
          "photo": imageTagsGeoModel.imag64,
          "tags": {
            "tag1": imageTagsGeoModel.tagA,
            "tag2": imageTagsGeoModel.tagB,
            "tag3": imageTagsGeoModel.tagC,
          },
          "volume": imageTagsGeoModel.slide,
        }
      }),
    );

    if (response.statusCode == 200) {
      print('Success ${response.statusCode}');
      return true;
    }
    if (response.statusCode >= 400) {
      print('Error ${response.statusCode}');
      return false;
    }
    return false;
  }
}
