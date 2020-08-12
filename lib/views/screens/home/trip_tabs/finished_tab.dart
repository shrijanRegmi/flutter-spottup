import 'package:flutter/material.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/services/firestore/hotel_provider.dart';
import 'package:motel/views/widgets/explore_widgets/best_deals_item.dart';

class FinishedTab extends StatelessWidget {
  final List<dynamic> finishedBookings;
  FinishedTab(this.finishedBookings);

  @override
  Widget build(BuildContext context) {
    return finishedBookings.length == 0
        ? _emptyBuilder()
        : ListView.builder(
            itemCount: finishedBookings.length,
            itemBuilder: (context, index) {
              return _itemBuilder(finishedBookings[index]);
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
            child: BestDealItem(
              bestDeal: hotelSnap.data,
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
              "You haven't completed any bookings",
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
