import 'package:flutter/material.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/services/firestore/hotel_provider.dart';
import 'package:motel/views/widgets/explore_widgets/best_deals_item.dart';

class UpcomingTab extends StatelessWidget {
  final List<dynamic> upcomingBookings;
  UpcomingTab(this.upcomingBookings);

  @override
  Widget build(BuildContext context) {
    return upcomingBookings.length == 0
        ? _emptyBuilder()
        : ListView.builder(
            itemCount: upcomingBookings.length,
            itemBuilder: (context, index) {
              return _itemBuilder(upcomingBookings[index]);
            },
          );
  }

  Widget _itemBuilder(String _hotelId) {
    return StreamBuilder<Hotel>(
      stream: HotelProvider(hotelId: _hotelId).hotelFromId,
      builder: (BuildContext context, AsyncSnapshot<Hotel> hotelSnap) {
        if (hotelSnap.hasData) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Column(
              children: <Widget>[
                Text(
                  '01 Oct - 07 Oct, 1 Room - 2 Adult',
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
