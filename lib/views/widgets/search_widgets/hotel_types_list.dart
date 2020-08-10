import 'package:flutter/material.dart';
import 'package:motel/models/app/hotel_types.dart';
import 'package:motel/views/widgets/search_widgets/hotel_types_item.dart';

class HotelTypesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hotelTypes.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: HotelTypesItem(
                imgPath: hotelTypes[index].imgPath,
                title: hotelTypes[index].title,
              ),
            );
          }
          return HotelTypesItem(
            imgPath: hotelTypes[index].imgPath,
            title: hotelTypes[index].title,
          );
        },
      ),
    );
  }
}
