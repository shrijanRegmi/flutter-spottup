import 'package:flutter/material.dart';
import 'package:motel/enums/booking_type.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/views/widgets/booking_tab_widgets/booking_list_item.dart';

class OtherBookingTab extends StatelessWidget {
  final List<ConfirmBooking> bookings;
  OtherBookingTab(this.bookings);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        return BookingListItem(bookings[index], BookingType.other);
      },
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }
}
