import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_tags_geo/bloc/geo/geo_bloc.dart';
import 'package:image_tags_geo/bloc/image/image_bloc.dart';
import 'package:image_tags_geo/bloc/main/main_bloc.dart';
import 'package:image_tags_geo/bloc/tag_vol/tag_vol_bloc.dart';
import 'package:image_tags_geo/service/image_tags_geo_service.dart';
import 'bloc/simple_bloc_delegate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'helpers/coustom_transition.dart';
import 'screens/image_tags_geo_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<MainBloc>(
            create: (context) =>
                MainBloc(imageTagsGeoService: ImageTagsGeoService())
                  ..add(AppStartMainEvent())),
        BlocProvider<GeoBloc>(
            create: (context) =>
                GeoBloc(imageTagsGeoService: ImageTagsGeoService())),
        BlocProvider<ImageBloc>(
            create: (context) =>
                ImageBloc(imageTagsGeoService: ImageTagsGeoService())),
        BlocProvider<TagVolBloc>(create: (context) => TagVolBloc()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
    pageTransitionsTheme: PageTransitionsTheme(
    builders: {
    TargetPlatform.android: CustomPageTransitionBuilder(),
    TargetPlatform.iOS: CustomPageTransitionBuilder(),
    },
    ),
    ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => ImageTagsGeo(),
      },
    );
  }
}
