import 'package:flutter/material.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:provider/provider.dart';

class BookingTabVm extends ChangeNotifier {
  final BuildContext context;
  BookingTabVm(this.context);

  // all bookings
  List<ConfirmBooking> get _bookingList =>
      Provider.of<List<ConfirmBooking>>(context) ?? [];

  // only new bookings
  List<ConfirmBooking> get newBookings {
    return _bookingList.where((booking) => !booking.isSeen).toList();
  }

  // only other bookings
  List<ConfirmBooking> get otherBookings {
    return _bookingList.where((booking) => booking.isSeen).toList();
  }

  // only contacted bookings
  List<ConfirmBooking> get contactedBookings {
    return _bookingList.where((booking) => booking.isContacted).toList();
  }
}
