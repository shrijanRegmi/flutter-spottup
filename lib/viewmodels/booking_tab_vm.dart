import 'package:flutter/material.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/services/firestore/hotel_provider.dart';
import 'package:provider/provider.dart';

class BookingTabVm extends ChangeNotifier {
  final BuildContext context;
  BookingTabVm(this.context);

  String _acceptDeclineText = '';
  TextEditingController _controller = TextEditingController();

  String get acceptDeclineText => _acceptDeclineText;

  // all bookings
  List<ConfirmHotelBooking> get _bookingList =>
      Provider.of<List<ConfirmHotelBooking>>(context) ?? [];

  // only new bookings
  List<ConfirmHotelBooking> get newBookings {
    return _bookingList
        .where((booking) => !booking.isAccepted && !booking.isDeclined)
        .toList();
  }

  // only other bookings
  List<ConfirmHotelBooking> get acceptedBookings {
    return _bookingList
        .where((booking) => booking.isAccepted && !booking.isDeclined)
        .toList();
  }

  // only contacted bookings
  List<ConfirmHotelBooking> get declinedBookings {
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

  // decline the booking
  declineBooking(String bookingId) async {
    return _showDeclineDialog(bookingId);
  }

  _showDeclineDialog(String bookingId) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reason'),
        content: TextFormField(
          minLines: 1,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Type your reason...',
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color(0xff45ad90),
              ),
            ),
          ),
          controller: _controller,
        ),
        actions: <Widget>[
          MaterialButton(
            textColor: Colors.red,
            child: Text(
              'Cancel',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          MaterialButton(
            textColor: Color(0xff45ad90),
            child: Text(
              'Done',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () async {
              if (_controller.text.trim() != '') {
                updateAcceptDeclineText('Declined');
                Navigator.pop(context);
                final _data = {
                  'is_declined': true,
                  'is_accepted': false,
                  'decline_text': _controller.text.trim(),
                };
                await HotelProvider().updateBookingData(_data, bookingId);
              }
            },
          ),
        ],
      ),
    );
  }

  // update value of accept decline text
  updateAcceptDeclineText(final String newVal) {
    _acceptDeclineText = newVal;
    notifyListeners();
  }
}
