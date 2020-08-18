import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class HotelPhotosItem extends StatelessWidget {
  final String photo;
  HotelPhotosItem(this.photo);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0),
      child: Container(
        width: 100.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image: DecorationImage(
            image: CachedNetworkImageProvider(photo),
            fit: BoxFit.cover,
          ),
          color: Colors.green[100],
        ),
      ),
    );
  }
}
