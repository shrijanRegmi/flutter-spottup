import 'package:flutter/material.dart';
import 'package:motel/models/firebase/tour_model.dart';
import 'package:motel/services/firestore/tour_provider.dart';
import 'package:motel/views/screens/home/view_all_screen.dart';
import 'package:motel/views/widgets/common_widgets/left_right_text.dart';
import 'package:motel/views/widgets/tour_view_widgets/tour_view_list_item.dart';

class BestTourDeals extends StatelessWidget {
  final List<Tour> bestDeals;
  BestTourDeals(this.bestDeals);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LeftRightText(
          leftText: 'Best tour services',
          onPressIcon: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewAllScreen(
                    title: 'Best tour services',
                    stream: TourProvider().allBestDeals,
                    listItem: (List list, int index) {
                      return TourViewListItem(tour: list[index]);
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
        return TourViewListItem(tour: bestDeals[index]);
      },
    );
  }
}
