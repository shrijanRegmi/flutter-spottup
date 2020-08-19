import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:motel/models/firebase/room_model.dart';

class HotelRoomItem extends StatelessWidget {
  final Room room;
  final smallImg;
  HotelRoomItem(this.room, {this.smallImg = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: smallImg ? 100.0 : 150.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(room.dp),
                  fit: BoxFit.cover,
                ),
                color: Colors.green[100],
              ),
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
            '\$${room.price}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
