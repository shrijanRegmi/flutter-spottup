import 'package:flutter/material.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/models/firebase/vehicle_model.dart';
import 'package:motel/services/firestore/vehicle_provider.dart';
import 'package:motel/views/widgets/common_widgets/left_right_text.dart';
import 'package:motel/views/widgets/vehicle_view_widgets/vehicle_view_list_item.dart';
import 'package:provider/provider.dart';

class PartnerVehiclesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return Column(
      children: [
        LeftRightText(
          leftText: 'My car/bus services',
          rightText: '',
          requiredIcon: false,
        ),
        SizedBox(
          height: 20.0,
        ),
        StreamBuilder<List<Vehicle>>(
            stream: VehicleProvider(appUser: _appUser).myVehicles,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final _vehicles = snapshot.data;
                return _vehicles.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 50.0),
                        child: Text(
                          "You don't have any service currently. Tap on 'Add a new Car/Bus service' to add a service",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: _vehicles.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return VehicleViewListItem(
                            vehicle: _vehicles[index],
                          );
                        },
                      );
              }
              return Container();
            }),
      ],
    );
  }
}
