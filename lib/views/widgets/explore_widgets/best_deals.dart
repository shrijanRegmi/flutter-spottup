import 'package:flutter/material.dart';
import 'package:motel/services/firestore/hotel_provider.dart';
import 'package:motel/views/screens/home/view_all_screen.dart';
import 'package:motel/views/widgets/common_widgets/left_right_text.dart';
import 'package:motel/views/widgets/explore_widgets/best_deals_item.dart';
import 'package:motel/models/firebase/hotel_model.dart';

class BestDeals extends StatelessWidget {
  final List<Hotel> bestDeals;
  final bool isEditing;
  BestDeals(this.bestDeals, {this.isEditing = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LeftRightText(
          leftText: 'Best deals',
          onPressIcon: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewAllScreen(
                    title: 'Best deals',
                    stream: HotelProvider().allBestDeals,
                    listItem: (List list, int index) {
                      return BestDealItem(
                          bestDeal: list[index], isEditing: isEditing);
                    }),
              ),
            );
          },
        ),
        _bestDealsList(),
      ],
    );
  }

  Widget _bestDealsList() {
    return ListView.builder(
      itemCount: bestDeals.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return BestDealItem(bestDeal: bestDeals[index]);
      },
    );
  }
}
