import 'package:flutter/material.dart';
import 'package:motel/enums/booking_type.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/services/firestore/hotel_provider.dart';
import 'package:provider/provider.dart';

class BookingTabVm extends ChangeNotifier {
  final BuildContext context;
  BookingTabVm(this.context);

  bool _isContacted = false;
  bool get isContacted => _isContacted;

  // all bookings
  List<ConfirmBooking> get _bookingList =>
      Provider.of<List<ConfirmBooking>>(context) ?? [];

  // only new bookings
  List<ConfirmBooking> get newBookings {
    return _bookingList.where((booking) => !booking.isSeen).toList();
  }

  // only other bookings
  List<ConfirmBooking> get otherBookings {
    return _bookingList
        .where((booking) => booking.isSeen && !booking.isContacted)
        .toList();
  }

  // only contacted bookings
  List<ConfirmBooking> get contactedBookings {
    return _bookingList.where((booking) => booking.isContacted).toList();
  }

  // update seen state
  updateSeenState(final BookingType type, final String bookingId) async {
    if (type == BookingType.neww) {
      final _data = {
        'is_seen': true,
      };
      return await HotelProvider().updateBookingData(_data, bookingId);
    }
  }

  // update value of is contacted
  updateIsContacted(final bool newVal) {
    _isContacted = newVal;
    notifyListeners();
  }

  // on press contacted value
  onPressedContactedBtn(final String bookingId) async {
    updateIsContacted(!_isContacted);
    final _data = {
      'is_contacted': _isContacted,
    };
    return await HotelProvider().updateBookingData(_data, bookingId);
  }
}
