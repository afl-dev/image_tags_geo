import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_tags_geo/bloc/geo/geo_bloc.dart';
import 'package:location/location.dart' as loc;

class Geo extends StatelessWidget {
  final double deviceHeight;

  const Geo({this.deviceHeight});

  static Future<bool> _checkGps() async {
    if (!await loc.Location.instance.serviceEnabled()) {
      bool locGps = await loc.Location.instance.requestService();
      return locGps;
    }
    return true;
  }

  Future<void> _getGpsButtonPressed(context) async {
    BlocProvider.of<GeoBloc>(context).add(
      UpdateGpsEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GeoBloc, GeoState>(builder: (context, state) {
      return Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        height: deviceHeight * 0.1,
        width: double.infinity,
        child: OutlineButton(
          borderSide: BorderSide(color: Colors.grey[400]),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          onPressed: () {
            _checkGps().then((value) {
              if (value) {
                _getGpsButtonPressed(context);
              }
            });
          },
          child: (state is DataGpsUpdated && state.longitude != null)
              ? Text(
                  '${state?.latitude}, ${state?.longitude}',
                  style: TextStyle(color: Colors.grey[600]),
                )
              : (state is DataGpsUpdating)
                  ? CircularProgressIndicator()
                  : Container(
                      alignment: Alignment.centerRight,
                      child: Icon(Icons.place)),
        ),
      );
    });
  }
}
