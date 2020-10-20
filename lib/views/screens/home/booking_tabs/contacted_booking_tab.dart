import 'package:flutter/material.dart';
import 'package:motel/enums/booking_type.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/views/widgets/booking_tab_widgets/booking_list_item.dart';

class DeclinedBookingTab extends StatelessWidget {
  final List<ConfirmHotelBooking> bookings;
  DeclinedBookingTab(this.bookings);
  @override
  Widget build(BuildContext context) {
    return bookings.isEmpty
        ? _emptyBuilder()
        : ListView.separated(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              return BookingListItem(bookings[index], BookingType.declined);
            },
            separatorBuilder: (context, index) {
              return Divider();
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
              "You don't have any declined bookings",
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
