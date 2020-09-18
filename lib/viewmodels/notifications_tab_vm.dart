import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/enums/notification_type.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/notification_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/user_provider.dart';
import 'package:motel/views/screens/home/open_booking_item_screen.dart';
import 'package:provider/provider.dart';

class NotificationTabVm extends ChangeNotifier {
  final BuildContext context;
  NotificationTabVm(this.context);

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<AppNotification> get notificationsList =>
      Provider.of<List<AppNotification>>(context);

  // read notification
  readNotification(final String uid, final String notifId) async {
    return await UserProvider(uid: uid).readNotification(notifId);
  }

  // screen navigation on btn pressed
  onNotifPressed(
      AppNotification notification, List<ConfirmBooking> bookingsList) async {
    switch (notification.type) {
      case NotificationType.bookingReceived:
        navigateToBookingOpenScreen(notification, bookingsList);
        break;
      default:
    }
  }

  // navigate to booking open screen
  navigateToBookingOpenScreen(
      AppNotification notification, List<ConfirmBooking> bookingsList) async {
    updateLoadingVal(true);

    final _booking = bookingsList.firstWhere(
        (booking) => booking.bookingId == notification.bookingId,
        orElse: () => null);

    if (_booking != null) {
      final _userSnap = await _booking.userRef.get();
      final _hotelSnap = await _booking.hotelRef.get();

      if (_userSnap.exists && _hotelSnap.exists) {
        final _appUser = AppUser.fromJson(_userSnap.data);
        final _hotel = Hotel.fromJson(_hotelSnap.data);

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OpenBookingItemScreen(
              _booking,
              _appUser,
              _hotel,
            ),
          ),
        );
      }
    }
    updateLoadingVal(false);
  }

  // update value of loading
  updateLoadingVal(final bool newVal) {
    _isLoading = newVal;
    notifyListeners();
  }
}
