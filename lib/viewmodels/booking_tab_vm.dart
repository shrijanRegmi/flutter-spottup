import 'package:flutter/material.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/services/firestore/hotel_provider.dart';
import 'package:provider/provider.dart';

class BookingTabVm extends ChangeNotifier {
  final BuildContext context;
  BookingTabVm(this.context);

  String _acceptDeclineText = '';
  String get acceptDeclineText => _acceptDeclineText;

  // all bookings
  List<ConfirmBooking> get _bookingList =>
      Provider.of<List<ConfirmBooking>>(context) ?? [];

  // only new bookings
  List<ConfirmBooking> get newBookings {
    return _bookingList
        .where((booking) => !booking.isAccepted && !booking.isDeclined)
        .toList();
  }

  // only other bookings
  List<ConfirmBooking> get acceptedBookings {
    return _bookingList
        .where((booking) => booking.isAccepted && !booking.isDeclined)
        .toList();
  }

  // only contacted bookings
  List<ConfirmBooking> get declinedBookings {
    return _bookingList
        .where((booking) => booking.isDeclined && !booking.isAccepted)
        .toList();
  }

  // accept the booking
  acceptBooking(String bookingId) async {
    updateAcceptDeclineText('Accepted');
    final _data = {
      'is_accepted': true,
      'is_declined': false,
    };
    return await HotelProvider().updateBookingData(_data, bookingId);
  }

  // accept the booking
  declineBooking(String bookingId) async {
    updateAcceptDeclineText('Declined');
    final _data = {
      'is_declined': true,
      'is_accepted': false,
    };
    return await HotelProvider().updateBookingData(_data, bookingId);
  }

  // update value of accept decline text
  updateAcceptDeclineText(final String newVal) {
    _acceptDeclineText = newVal;
    notifyListeners();
  }
}
