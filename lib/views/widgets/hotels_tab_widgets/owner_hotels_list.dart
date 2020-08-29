import 'package:flutter/material.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/views/widgets/common_widgets/left_right_text.dart';
import 'package:motel/views/widgets/explore_widgets/best_deals_item.dart';

class OwnerHotelList extends StatelessWidget {
  final List<Hotel> hotelList;
  final bool isEditing;
  OwnerHotelList(this.hotelList, {this.isEditing = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LeftRightText(
          leftText: 'My Hotels',
          rightText: '',
          requiredIcon: false,
        ),
        SizedBox(
          height: 20.0,
        ),
        ListView.builder(
          itemCount: 10,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return BestDealItem(
              bestDeal: hotelList[0],
              isEditing: isEditing,
            );
          },
        ),
      ],
    );
  }
}
