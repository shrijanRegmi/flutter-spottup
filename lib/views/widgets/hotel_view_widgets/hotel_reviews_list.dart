import 'package:flutter/material.dart';
import 'package:motel/views/widgets/common_widgets/left_right_text.dart';
import 'package:motel/views/widgets/hotel_view_widgets/hotel_review_item.dart';

class HotelReviewsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        LeftRightText(leftText: 'Reviews'),
        _reviewsList(context),
      ],
    );
  }

  Widget _reviewsList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: ListView.builder(
        itemCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return HotelReviewItem();
        },
      ),
    );
  }
}
