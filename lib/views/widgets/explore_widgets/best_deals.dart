import 'package:flutter/material.dart';
import 'package:motel/views/widgets/common_widgets/left_right_text.dart';
import 'package:motel/views/widgets/explore_widgets/best_deals_item.dart';

class BestDeals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LeftRightText(
          leftText: 'Best deals',
          onPressIcon: () {},
        ),
        _bestDealsList(),
      ],
    );
  }

  Widget _bestDealsList() {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return BestDealItem();
      },
    );
  }
}
