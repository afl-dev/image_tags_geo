import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_tags_geo/bloc/tag_vol/tag_vol_bloc.dart';


class TagVolWidget extends StatefulWidget {
  //final Function onSaveTagVol;

//  TagVolWidget({Key key, this.tagA, this.tagB, this.tagC, this.slide, this.onSaveTagVol})
  //   : super(key: key);

  @override
  _TagVolWidgetState createState() => _TagVolWidgetState();
}

class _TagVolWidgetState extends State<TagVolWidget> {
  bool tagA;
  bool tagB;
  bool tagC;
  double slide;

  TagVolBloc _tagVolBloc;

  @override
  void initState() {
    super.initState();
    _tagVolBloc = BlocProvider.of<TagVolBloc>(context);
  }

  @override
  void dispose() {
    //_tagVolBloc.close();
    super.dispose();
  }


  //void _saveData() {
  //   widget.onSaveTagVol(widget.tagA, widget.tagB, widget.tagC, widget.slide);
  // }

  @override
  Widget build(BuildContext context) {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double deviceWidth = MediaQuery.of(context).size.width;
    return BlocBuilder<TagVolBloc, TagVolState>(builder: (context, state) {
      if (state is TagVolStateInitial) {
        tagA = state.tagA;
        tagB = state.tagB;
        tagC = state.tagC;
        slide = state.slide;
      }
      if (state is TagUpdatedTagVolState) {
        tagA = state.tagA;
        tagB = state.tagB;
        tagC = state.tagC;
        slide = state.slide;
      }
      return Column(
        children: <Widget>[
          Container(
            height: deviceHeight * 0.075,
            width: double.infinity,
            margin: EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                IconButton(
                  icon: Icon(Icons.control_point),
                  color: tagA ? Colors.green : Colors.grey,
                  onPressed: () {
                    tagA = !tagA;
                    _tagVolBloc.add(
                        UpdateTagVolEvent(tagA: tagA, tagB: tagB, tagC: tagC));
                  },
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.gps_fixed),
                  color: tagB ? Colors.green : Colors.grey,
                  onPressed: () {
                    tagB = !tagB;
                    _tagVolBloc.add(
                        UpdateTagVolEvent(tagA: tagA, tagB: tagB, tagC: tagC));
                  },
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.accessibility_new),
                  color: tagC ? Colors.green : Colors.grey,
                  onPressed: () {
                    tagC = !tagC;
                    // _saveData();
                    _tagVolBloc.add(
                        UpdateTagVolEvent(tagA: tagA, tagB: tagB, tagC: tagC));
                  },
                ),
                Spacer(),
              ],
            ),
          ),
          Container(
            height: deviceHeight * 0.075,
            width: double.infinity,
            margin: EdgeInsets.only(bottom: 10),
            child: Slider.adaptive(
              value: slide,
              onChanged: (newSlide) {
                slide = newSlide;
                _tagVolBloc.add(
                  UpdateSlideTagVolEvent(slide: newSlide),
                );
              },
              min: 0,
              max: 100,
              divisions: 20,
              label: '$slide',
            ),
          ),
        ],
      );
    });
  }
}
