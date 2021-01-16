import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:motel/enums/booking_for_type.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/enums/notification_type.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/notification_model.dart';
import 'package:motel/models/firebase/tour_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/models/firebase/vehicle_model.dart';
import 'package:motel/services/firestore/user_provider.dart';
import 'package:motel/views/screens/home/booking_accepted_screen.dart';
import 'package:motel/views/screens/home/booking_declined_screen.dart';
import 'package:motel/views/screens/home/open_booking_item_screen.dart';
import 'package:motel/views/screens/home/open_tour_booking_item_screen.dart';
import 'package:motel/views/screens/home/open_vehicle_booking_item_screen.dart';
import 'package:motel/views/screens/home/payment_screenshot_screen.dart';
import 'package:motel/views/screens/home/tour_payment_screenshot_screen.dart';
import 'package:motel/views/screens/home/vehicle_payment_screenshot_screen.dart';
import 'package:provider/provider.dart';

class NotificationTabVm extends ChangeNotifier {
  final BuildContext context;
  NotificationTabVm(this.context);

  bool _isLoading = false;
  final _ref = FirebaseFirestore.instance;

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
      case NotificationType.declined:
        navigateToBookingDeclinedScreen(notification, bookingsList);
        break;
      case NotificationType.accepted:
        navigateToBookingAcceptedScreen(notification, bookingsList);
        break;
      case NotificationType.paymentReceived:
        navigateToPaymentScreenshotScreen(notification, bookingsList);
        break;
      default:
    }
  }

  // goto booking open screen
  navigateToBookingOpenScreen(
      AppNotification notification, List<ConfirmBooking> bookingsList) async {
    updateLoadingVal(true);

    bool _bookingExists = false;
    var _booking = bookingsList.firstWhere(
        (booking) => booking.bookingId == notification.bookingId,
        orElse: () => null);

    if (_booking == null) {
      final _bookingRef = _ref
          .collection('bookings')
          .where('id', isEqualTo: notification.bookingId)
          .limit(1);

      final _bookingSnap = await _bookingRef.get();

      if (_bookingSnap.docs.isNotEmpty) {
        _booking = ConfirmBooking.fromJson(_bookingSnap.docs.first.data());
        _bookingExists = true;
      }
    } else {
      _bookingExists = true;
    }

    if (_bookingExists) {
      final _type = _booking.type;
      if (_type == BookingForType.hotel) {
        final _userSnap = await _booking.userRef.get();
        final _hotelSnap = await _booking.hotelRef.get();

        if (_userSnap.exists && _hotelSnap.exists) {
          final _appUser = AppUser.fromJson(_userSnap.data());
          final _hotel = Hotel.fromJson(_hotelSnap.data());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OpenBookingItemScreen(
                _booking,
                _appUser,
                _hotel,
                admin: notification.admin,
              ),
            ),
          );
        }
      } else if (_type == BookingForType.tour) {
        final _userSnap = await _booking.userRef.get();
        final _hotelSnap = await _booking.tourRef.get();

        if (_userSnap.exists && _hotelSnap.exists) {
          final _appUser = AppUser.fromJson(_userSnap.data());
          final _hotel = Tour.fromJson(_hotelSnap.data());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OpenTourBookingItemScreen(
                _booking,
                _appUser,
                _hotel,
                admin: notification.admin,
              ),
            ),
          );
        }
      } else if (_type == BookingForType.vehicle) {
        final _userSnap = await _booking.userRef.get();
        final _hotelSnap = await _booking.vehicleRef.get();

        if (_userSnap.exists && _hotelSnap.exists) {
          final _appUser = AppUser.fromJson(_userSnap.data());
          final _hotel = Vehicle.fromJson(_hotelSnap.data());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OpenVehicleBookingItemScreen(
                _booking,
                _appUser,
                _hotel,
                admin: notification.admin,
              ),
            ),
          );
        }
      }
    }
    updateLoadingVal(false);
  }

  // goto declined screen
  navigateToBookingDeclinedScreen(
      AppNotification notification, List<ConfirmBooking> bookingsList) async {
    updateLoadingVal(true);

    bool _bookingExists = false;
    var _booking = bookingsList.firstWhere(
        (booking) => booking.bookingId == notification.bookingId,
        orElse: () => null);

    if (_booking == null) {
      final _bookingRef = _ref
          .collection('bookings')
          .where('id', isEqualTo: notification.bookingId)
          .limit(1);

      final _bookingSnap = await _bookingRef.get();

      if (_bookingSnap.docs.isNotEmpty) {
        _booking = ConfirmBooking.fromJson(_bookingSnap.docs.first.data());
        _bookingExists = true;
      }
    } else {
      _bookingExists = true;
    }

    if (_bookingExists) {
      if (_booking.type == BookingForType.hotel) {
        final _hotelSnap = await _booking.hotelRef.get();

        if (_hotelSnap.exists) {
          final _hotel = Hotel.fromJson(_hotelSnap.data());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingDeclinedScreen(
                _booking,
                _hotel,
              ),
            ),
          );
        }
      } else if (_booking.type == BookingForType.tour) {
        final _hotelSnap = await _booking.tourRef.get();

        if (_hotelSnap.exists) {
          final _hotel = Tour.fromJson(_hotelSnap.data());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingDeclinedScreen(
                _booking,
                _hotel,
              ),
            ),
          );
        }
      } else if (_booking.type == BookingForType.vehicle) {
        final _hotelSnap = await _booking.vehicleRef.get();

        if (_hotelSnap.exists) {
          final _hotel = Vehicle.fromJson(_hotelSnap.data());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingDeclinedScreen(
                _booking,
                _hotel,
              ),
            ),
          );
        }
      }
    }

    updateLoadingVal(false);
  }

  // goto accepted screen
  navigateToBookingAcceptedScreen(
      AppNotification notification, List<ConfirmBooking> bookingsList) async {
    updateLoadingVal(true);

    bool _bookingExists = false;
    var _booking = bookingsList.firstWhere(
        (booking) => booking.bookingId == notification.bookingId,
        orElse: () => null);

    if (_booking == null) {
      final _bookingRef = _ref
          .collection('bookings')
          .where('id', isEqualTo: notification.bookingId)
          .limit(1);

      final _bookingSnap = await _bookingRef.get();

      if (_bookingSnap.docs.isNotEmpty) {
        _booking = ConfirmBooking.fromJson(_bookingSnap.docs.first.data());
        _bookingExists = true;
      }
    } else {
      _bookingExists = true;
    }

    if (_bookingExists) {
      if (_booking.type == BookingForType.hotel) {
        final _hotelSnap = await _booking.hotelRef.get();

        if (_hotelSnap.exists) {
          final _hotel = Hotel.fromJson(_hotelSnap.data());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingAcceptedScreen(
                _booking,
                _hotel,
                admin: notification.admin,
              ),
            ),
          );
        }
      } else if (_booking.type == BookingForType.tour) {
        final _hotelSnap = await _booking.tourRef.get();

        if (_hotelSnap.exists) {
          final _hotel = Tour.fromJson(_hotelSnap.data());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingAcceptedScreen(
                _booking,
                _hotel,
              ),
            ),
          );
        }
      } else if (_booking.type == BookingForType.vehicle) {
        final _hotelSnap = await _booking.vehicleRef.get();

        if (_hotelSnap.exists) {
          final _hotel = Vehicle.fromJson(_hotelSnap.data());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingAcceptedScreen(
                _booking,
                _hotel,
              ),
            ),
          );
        }
      }
    }

    updateLoadingVal(false);
  }

  // goto payment screenshot screen
  navigateToPaymentScreenshotScreen(
      AppNotification notification, List<ConfirmBooking> bookingsList) async {
    updateLoadingVal(true);

    bool _bookingExists = false;
    var _booking = bookingsList.firstWhere(
        (booking) => booking.bookingId == notification.bookingId,
        orElse: () => null);

    if (_booking == null) {
      final _bookingRef = _ref
          .collection('bookings')
          .where('id', isEqualTo: notification.bookingId)
          .limit(1);

      final _bookingSnap = await _bookingRef.get();

      if (_bookingSnap.docs.isNotEmpty) {
        _booking = ConfirmBooking.fromJson(_bookingSnap.docs.first.data());
        _bookingExists = true;
      }
    } else {
      _bookingExists = true;
    }

    if (_bookingExists) {
      if (_booking.type == BookingForType.hotel) {
        final _userSnap = await _booking.userRef.get();
        final _hotelSnap = await _booking.hotelRef.get();

        if (_userSnap.exists && _hotelSnap.exists) {
          final _appUser = AppUser.fromJson(_userSnap.data());
          final _hotel = Hotel.fromJson(_hotelSnap.data());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentScreenshotScreen(
                _booking,
                _hotel,
                _appUser,
              ),
            ),
          );
        }
      } else if (_booking.type == BookingForType.tour) {
        final _userSnap = await _booking.userRef.get();
        final _hotelSnap = await _booking.tourRef.get();

        if (_userSnap.exists && _hotelSnap.exists) {
          final _appUser = AppUser.fromJson(_userSnap.data());
          final _hotel = Tour.fromJson(_hotelSnap.data());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TourPaymentScreenshotScreen(
                _booking,
                _hotel,
                _appUser,
              ),
            ),
          );
        }
      } else if (_booking.type == BookingForType.vehicle) {
        final _userSnap = await _booking.userRef.get();
        final _hotelSnap = await _booking.vehicleRef.get();

        if (_userSnap.exists && _hotelSnap.exists) {
          final _appUser = AppUser.fromJson(_userSnap.data());
          final _hotel = Vehicle.fromJson(_hotelSnap.data());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VehiclePaymentScreenshotScreen(
                _booking,
                _hotel,
                _appUser,
              ),
            ),
          );
        }
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
