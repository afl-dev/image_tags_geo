import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_tags_geo/bloc/image/image_bloc.dart';

class ImageInput extends StatefulWidget {
  //final Function onSelectImage;

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  ImageBloc _imageBloc;

  @override
  void initState() {
    super.initState();
    _imageBloc = BlocProvider.of<ImageBloc>(context);
  }

  @override
  void dispose() {
    //_imageBloc.close();
    super.dispose();
  }

  Future<void> _takePicture() async {
    _imageBloc.add(
      UpdatingImageEvent(),
    );
    final imageFile = await ImagePicker.pickImage(
        source: ImageSource.camera,
        //maxWidth: 1200,
        imageQuality: 50);
    if (imageFile != null) {
      _imageBloc.add(UpdatedImageEvent(storedImage: imageFile));
    } else {
      _imageBloc.add(InitialImageEvent());
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<ImageBloc, ImageState>(builder: (context, state) {
      return Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: _takePicture,
            child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 10, bottom: 10),
                height: deviceHeight * 0.37,
                width: deviceWidth * 0.85,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[400]),
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
                child:
                    (state is UpdatedImageState && state?.storedImage != null)
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              state.storedImage,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          )
                        : (state is UpdatingImageState)
                            ? CircularProgressIndicator()
                            : Align(
                                child: Icon(
                                  Icons.photo_camera,
                                  size: 40,
                                ),
                                alignment: Alignment.center,
                              )),
          ),
        ],
      );
    });
  }
}
