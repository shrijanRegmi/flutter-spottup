import 'package:flutter/material.dart';
import 'package:motel/enums/booking_type.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/views/widgets/booking_tab_widgets/booking_list_item.dart';

class NewBookingTab extends StatelessWidget {
  final List<ConfirmBooking> bookings;
  NewBookingTab(this.bookings);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return BookingListItem(bookings[index], BookingType.neww);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}
