import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/views/widgets/hotel_view_widgets/expanded_hotel_view_screen.dart';

class HotelRoomItem extends StatelessWidget {
  final Hotel room;
  final smallImg;
  final Function onPressed;
  HotelRoomItem(this.room, {this.smallImg = false, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!smallImg) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ExpandedHotelViewScreen(hotel: room, isRoom: true),
            ),
          );
        } else {
          onPressed(room);
        }
      },
      child: Container(
        width: smallImg ? 150.0 : 200.0,
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: smallImg ? 100 : 140.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(room.dp),
                    fit: BoxFit.cover,
                  ),
                  color: Colors.green[100],
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                room.name,
                style: TextStyle(
                  fontSize: smallImg ? 12.0 : 14.0,
                ),
              ),
              Text(
                'Rs ${room.getPrice()}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
