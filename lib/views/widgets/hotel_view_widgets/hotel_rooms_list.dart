import 'package:flutter/material.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/services/firestore/hotel_provider.dart';
import 'package:motel/views/widgets/common_widgets/left_right_text.dart';
import 'package:motel/views/widgets/hotel_view_widgets/hotel_room_item.dart';

class HotelRoomsList extends StatelessWidget {
  final String hotelId;
  final bool smallImg;
  final Function(Hotel room) onPressed;
  HotelRoomsList(this.hotelId, {this.smallImg = false, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Hotel>>(
        stream: HotelProvider(hotelId: hotelId).roomsList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.isEmpty
                ? Container()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (!smallImg)
                        LeftRightText(
                          leftText: 'Rooms',
                          rightText: '',
                          requiredIcon: false,
                        ),
                      SizedBox(
                        height: 20.0,
                      ),
                      _roomsList(context, snapshot.data),
                      if (!smallImg)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          child: Divider(),
                        ),
                    ],
                  );
          }
          return Container();
        });
  }

  Widget _roomsList(context, data) {
    return Container(
      height: smallImg ? 120.0 : 180.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: data.length,
        itemBuilder: (context, index) {
          if (index == 0 && !smallImg) {
            return Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: HotelRoomItem(
                data[index],
                smallImg: smallImg,
                onPressed: onPressed,
              ),
            );
          }
          return HotelRoomItem(
            data[index],
            smallImg: smallImg,
            onPressed: onPressed,
          );
        },
      ),
    );
  }
}
