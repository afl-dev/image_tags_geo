import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:image_tags_geo/service/image_tags_geo_service.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sysPaths;

part 'image_event.dart';

part 'image_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImageTagsGeoService imageTagsGeoService;
  File storedImage;

  ImageBloc({this.storedImage, this.imageTagsGeoService});

  @override
  ImageState get initialState => InitialImageState();

  @override
  Stream<ImageState> mapEventToState(ImageEvent event) async* {
    if (event is UpdatingImageEvent) {
      yield UpdatingImageState();
    }

    if (event is UpdatedImageEvent) {
      yield* _updateImage(event);
    }

    if (event is InitialImageEvent) {
      yield InitialImageState();
    }
    if (event is CleanDataImageEvent) {
      storedImage = null;
      yield UpdatedImageState(storedImage: storedImage);
    }
  }

  Stream<ImageState> _updateImage(event) async* {
    if (event is UpdatedImageEvent) {
      final appDir = await sysPaths.getApplicationDocumentsDirectory();
      try {
        final fileName = path.basename(event.storedImage.path);
        final pathImage = '${appDir.path}/$fileName';
        await imageTagsGeoService.saveShared('imagePath', pathImage);
        storedImage = await event.storedImage.copy(pathImage);
      } catch (error) {
        throw (error);
      }
      yield UpdatedImageState(storedImage: storedImage
          //await event.storedImage.copy(pathImage)
          );
    }
  }

/* Stream<ImageState> _readChangeStateImage(event) async* {
    final pathImage = await imageTagsGeoService.getShared('imagePath');
    yield UpdatedImageState(
        storedImage: await event.storedImage.copy(pathImage));
  }*/
}
