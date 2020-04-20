import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_tags_geo/bloc/geo/geo_bloc.dart';
import 'package:image_tags_geo/bloc/image/image_bloc.dart';
import 'package:image_tags_geo/bloc/main/main_bloc.dart';
import 'package:image_tags_geo/bloc/tag_vol/tag_vol_bloc.dart';
import 'package:image_tags_geo/models/image_tags_geo_model.dart';
import 'package:image_tags_geo/screens/splash_screen.dart';
import 'package:image_tags_geo/widgets/geo_widget.dart';
import 'package:image_tags_geo/widgets/image_button_widget.dart';
import 'package:image_tags_geo/widgets/splash_widget.dart';
import 'package:image_tags_geo/widgets/tag_vol_widget.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageTagsGeo extends StatefulWidget {
  @override
  _ImageTagsGeoState createState() => _ImageTagsGeoState();
}

class _ImageTagsGeoState extends State<ImageTagsGeo>
    with WidgetsBindingObserver {
  final PermissionHandler _permissionHandler = PermissionHandler();
  ImageTagsGeoModel _imageTagsGeoModel = ImageTagsGeoModel();
  GeoBloc _geoBloc;
  ImageBloc _imageBloc;
  TagVolBloc _tagVolBloc;
  bool gpsGranted = false;
  bool cameraGranted = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      //  BlocProvider.of<MainBloc>(context).add(ResumedAppMainEvent());
    }
  }

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _geoBloc = BlocProvider.of<GeoBloc>(context);
    _imageBloc = BlocProvider.of<ImageBloc>(context);
    _tagVolBloc = BlocProvider.of<TagVolBloc>(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _geoBloc.close();
    _imageBloc.close();
    _tagVolBloc.close();
    super.dispose();
  }

  Future<void> _cleanData() async {
    _geoBloc.add(
      CleanDataGpsEvent(),
    );
    _imageBloc.add(CleanDataImageEvent());
    _tagVolBloc.add(CleanDataTagVolEven());
    /* Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (BuildContext context) {
      return ImageTagsGeo();
    }));*/
  }

  Future _setDataPost(context) async {
    _imageTagsGeoModel.latitude = _geoBloc?.latitude;
    _imageTagsGeoModel.longitude = _geoBloc?.longitude;
    _imageTagsGeoModel.id =
        DateTime.now().millisecondsSinceEpoch + Random().nextInt(100 - 1);
    _imageTagsGeoModel.dateTime = DateTime.now();
    _imageTagsGeoModel.image = _imageBloc?.storedImage;
    _imageTagsGeoModel.tagA = _tagVolBloc?.tagA;
    _imageTagsGeoModel.tagB = _tagVolBloc?.tagB;
    _imageTagsGeoModel.tagC = _tagVolBloc?.tagC;
    _imageTagsGeoModel.slide = _tagVolBloc?.slide;
  }

  Future<void> _showDialog(context, textMes, success) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            '$textMes',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.redAccent),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          actions: <Widget>[
            Align(
              alignment: Alignment.center,
              child: FlatButton(
                child: Text(
                  'Ok',
                  style: TextStyle(fontSize: 14),
                ),
                //textColor: Colors.redAccent,
                onPressed: () {
                  success ? _cleanData() : Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /*void _onSaveTagVol(tagA, tagB, tagC, slide) {
    _tagA = tagA;
    _tagB = tagB;
    _tagC = tagC;
    _slide = slide;
  }*/

  Future<void> _postRequest(context) async {
    await _setDataPost(context);
    BlocProvider.of<MainBloc>(context).add(
      PostRequestMainEvent(imageTagsGeoModel: _imageTagsGeoModel),
    );
  }

  Future<void> requestPermission({Function onPermissionDenied}) async {
    _permissionHandler.requestPermissions([
      if (!gpsGranted) PermissionGroup.location,
      if (!cameraGranted) PermissionGroup.camera
    ]);
  }

  // Future<void> requestCameraPermission({Function onPermissionDenied}) async {
  // var granted = await
  //      _permissionHandler.requestPermissions([PermissionGroup.camera]);
  /* if (!granted) {
     // onPermissionDenied();
    }
    return granted;*/
  //print(granted.toString());
  //}

  @override
  void didUpdateWidget(ImageTagsGeo oldWidget) {
    requestPermission();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is EmptyDataInputMainState) {
          const mess = [
            'Не заполнено: \n геопозиция',
            'Не заполнено: \n фото',
            'Не заполнено: \n геопозиция, фото',
          ];
          var message = !state.isValidGps
              ? !state.isValidImage ? mess[2] : mess[0]
              : mess[1];
          _showDialog(context, message, false);
        }
        if (state is PostErrorMainState) {
          _showDialog(context, 'Ошибка передачи, повторите', false);
        }
        if (state is PostUpdatedMainState) {
          _showDialog(context, 'Успешно!', true);
        }
      },
      builder: (context, state) {
        if (state is InitialMainState) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Кабинет'),
              actions: <Widget>[
                IconButton(
                    icon: Icon(Icons.clear, color: Colors.white, size: 35.0),
                    onPressed: () {
                      _cleanData();
                    }), // action button
              ],
            ),
            body: Center(
              child: Container(
                height: deviceHeight,
                width: deviceWidth * 0.85,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Информация',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Geo(deviceHeight: deviceHeight),
                    // ImageInput(_selectImage, _pickedImage, imageLoading),
                    ImageInput(),
                    TagVolWidget(),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      height: deviceHeight * 0.08,
                      width: double.infinity,
                      child: FlatButton(
                        child: Text(
                          'Отправить',
                          style: TextStyle(fontSize: 18),
                        ),
                        color: Colors.blue,
                        onPressed: () {
                          _postRequest(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
        if (state is PostUpdatingMainState) {
          return LoadingIndicator();
        }
        return SplashPage();
      },
    );
  }
}
