import 'package:flutter/material.dart';
import 'package:motel/models/app/hotel_features.dart';
import 'package:motel/views/widgets/common_widgets/left_right_text.dart';

class HotelFeaturesList extends StatelessWidget {
  final List<HotelFeatures> features;
  HotelFeaturesList(this.features);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        LeftRightText(
          leftText: 'Facilities',
          rightText: '',
          requiredIcon: false,
        ),
        _hotelFeaturesGrid(),
      ],
    );
  }

  _hotelFeaturesGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 30.0,
          mainAxisSpacing: 20.0,
          childAspectRatio: 7 / 1,
        ),
        itemCount: features.length,
        itemBuilder: (context, index) {
          return Container(
            // color: Colors.orange,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(features[index].title),
                Icon(
                  Icons.check,
                  color: Color(0xff45ad90),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
