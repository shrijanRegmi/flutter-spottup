import 'package:flutter/material.dart';
import 'package:motel/models/firebase/vehicle_model.dart';
import 'package:motel/services/firestore/vehicle_provider.dart';
import 'package:motel/views/screens/home/view_all_screen.dart';
import 'package:motel/views/widgets/common_widgets/left_right_text.dart';
import 'package:motel/views/widgets/vehicle_view_widgets/vehicle_view_list_item.dart';

class BestVehicleDeals extends StatelessWidget {
  final List<Vehicle> bestDeals;
  BestVehicleDeals(this.bestDeals);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        LeftRightText(
          leftText: 'Best car/bus services',
          onPressIcon: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ViewAllScreen(
                    title: 'Best car/bus services',
                    stream: VehicleProvider().allBestDeals,
                    listItem: (List list, int index) {
                      return VehicleViewListItem(vehicle: list[index]);
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
        return VehicleViewListItem(vehicle: bestDeals[index]);
      },
    );
  }
}
