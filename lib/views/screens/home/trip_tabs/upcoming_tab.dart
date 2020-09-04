import 'package:flutter/material.dart';
import 'package:motel/helpers/date_helper.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/upcomming_bookings_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/hotel_provider.dart';
import 'package:motel/services/firestore/user_provider.dart';
import 'package:motel/views/widgets/explore_widgets/best_deals_item.dart';
import 'package:provider/provider.dart';

class UpcomingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return StreamBuilder<List<UpcomingBooking>>(
      stream: UserProvider(uid: _appUser.uid).upcomingBookings,
      builder: (context, snap) {
        if (snap.hasData) {
          final _upcomingBookings = snap.data;
          return _upcomingBookings.length == 0
              ? _emptyBuilder()
              : ListView.builder(
                  itemCount: _upcomingBookings.length,
                  itemBuilder: (context, index) {
                    return _itemBuilder(_upcomingBookings[index]);
                  },
                );
        }
        return Container();
      },
    );
  }

  Widget _itemBuilder(UpcomingBooking upcomingBookings) {
    return StreamBuilder<Hotel>(
      stream: HotelProvider(hotelRef: upcomingBookings.hotelRef).hotelFromRef,
      builder: (BuildContext context, AsyncSnapshot<Hotel> hotelSnap) {
        if (hotelSnap.hasData) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              children: <Widget>[
                Text(
                  '${DateHelper().getFormattedDate(upcomingBookings.checkIn)} - ${DateHelper().getFormattedDate(upcomingBookings.checkOut)}',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                BestDealItem(
                  bestDeal: hotelSnap.data,
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _emptyBuilder() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 100.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              "You don't have any upcoming bookings",
              style: TextStyle(
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
