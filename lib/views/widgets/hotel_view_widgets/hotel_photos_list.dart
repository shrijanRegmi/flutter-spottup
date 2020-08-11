import 'package:flutter/material.dart';
import 'package:motel/views/screens/home/view_all_screen.dart';
import 'package:motel/views/widgets/common_widgets/left_right_text.dart';
import 'package:motel/views/widgets/hotel_view_widgets/hotel_photos_item.dart';

class HotelPhotosList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        LeftRightText(
          leftText: 'Photos',
          onPressIcon: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewAllScreen(
                  title: 'Photos - Grand Royal Hotel',
                  isGrid: true,
                ),
              ),
            );
          },
        ),
        SizedBox(
          height: 20.0,
        ),
        _photosList(context),
      ],
    );
  }

  Widget _photosList(BuildContext context) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: HotelPhotosItem(),
            );
          }
          return HotelPhotosItem();
        },
      ),
    );
  }
}
