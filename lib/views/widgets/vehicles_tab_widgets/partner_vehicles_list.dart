import 'package:flutter/material.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/hotel_provider.dart';
import 'package:motel/views/widgets/common_widgets/left_right_text.dart';
import 'package:motel/views/widgets/explore_widgets/best_deals_item.dart';
import 'package:provider/provider.dart';

class PartnerVehiclesList extends StatelessWidget {
  final List<Hotel> hotelList;
  final bool isEditing;
  PartnerVehiclesList(this.hotelList, {this.isEditing = false});

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return Column(
      children: [
        LeftRightText(
          leftText: 'My Car/Bus services',
          rightText: '',
          requiredIcon: false,
        ),
        SizedBox(
          height: 20.0,
        ),
        StreamBuilder<List<Hotel>>(
            stream: HotelProvider(uid: _appUser.uid).myHotels,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final _hotels = snapshot.data;
                return _hotels.isEmpty
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
                        itemCount: _hotels.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return BestDealItem(
                            bestDeal: _hotels[index],
                            isEditing: isEditing,
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
