import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:motel/enums/booking_type.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/views/screens/home/booking_accepted_screen.dart';
import 'package:motel/views/screens/home/booking_declined_screen.dart';
import 'package:motel/views/screens/home/open_booking_item_screen.dart';
import 'package:motel/views/screens/home/payment_screenshot_screen.dart';

class FirebaseMessagingProvider {
  final String uid;
  final BuildContext context;
  FirebaseMessagingProvider({this.uid, this.context});

  final _ref = FirebaseFirestore.instance;
  final _firebaseMessaging = FirebaseMessaging();

  Future configureMessaging() async {
    _firebaseMessaging.configure(
      onLaunch: (message) {
        final _data = message['data'] ?? {};
        final _screen = _data['screen'] ?? '';
        final _id = _data['id'] ?? '';

        switch (_screen) {
          case 'booking-received-screen':
            return _openBookingScreen(_id);
            break;
          case 'booking-accept-decline-screen':
            return _openBookingAcceptDeclineScreen(_id);
            break;
          case 'payment-screenshot-received-screen':
            return _openPaymentScreenshotScreen(_id);
            break;
          default:
        }
        return null;
      },
      onResume: (message) {
        final _data = message['data'] ?? {};
        final _screen = _data['screen'] ?? '';
        final _id = _data['id'] ?? '';

        switch (_screen) {
          case 'booking-received-screen':
            return _openBookingScreen(_id);
            break;
          case 'booking-accept-decline-screen':
            return _openBookingAcceptDeclineScreen(_id);
            break;
          case 'payment-screenshot-received-screen':
            return _openPaymentScreenshotScreen(_id);
            break;
          default:
        }
        return null;
      },
    );
  }

  Future saveDevice() async {
    try {
      final _deviceInfo = DeviceInfoPlugin();
      final _androidInfo = await _deviceInfo.androidInfo;

      final _deviceRef = _ref
          .collection('users')
          .doc(uid)
          .collection('devices')
          .doc(_androidInfo.androidId);

      final _token = await _firebaseMessaging.getToken();
      print('Success: saving device info to firestore');
      await _deviceRef.set({'token': _token});
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!! saving device info to firestore');
      return null;
    }
  }

  Future removeDevice() async {
    try {
      final _deviceInfo = DeviceInfoPlugin();
      final _androidInfo = await _deviceInfo.androidInfo;

      final _deviceRef = _ref
          .collection('users')
          .doc(uid)
          .collection('devices')
          .doc(_androidInfo.androidId);

      print(
          'Success: Deleting device ${_androidInfo.androidId} info from firestore');
      await _deviceRef.delete();
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!! Deleting device info from firestore');
      return null;
    }
  }

  _openBookingScreen(final String bookingId) async {
    try {
      final _bookingRef =
          _ref.collection('bookings').where('id', isEqualTo: bookingId);
      final _bookingSnap = await _bookingRef.get();

      ConfirmBooking _booking;

      if (_bookingSnap.docs.isNotEmpty) {
        _bookingSnap.docs.forEach((docSnap) {
          if (docSnap.exists) {
            _booking = ConfirmBooking.fromJson(docSnap.data());
          }
        });
      }

      if (_booking != null) {
        final _userRef = _booking.userRef;
        final _hotelRef = _booking.hotelRef;

        final _userSnap = await _userRef.get();
        final _hotelSnap = await _hotelRef.get();

        if (_userSnap.exists && _hotelSnap.exists) {
          final _appUser = AppUser.fromJson(_userSnap.data());
          final _hotel = Hotel.fromJson(_hotelSnap.data());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OpenBookingItemScreen(
                _booking,
                _appUser,
                _hotel,
                bookingType: BookingType.neww,
              ),
            ),
          );
        }
        print('Success: Opening booking screen');
      }
    } catch (e) {
      print(e);
      print('Error!!! Opening booking screen');
    }
  }

  // navigate to booking-accept-decline screen
  _openBookingAcceptDeclineScreen(final String bookingId) async {
    try {
      final _bookingRef =
          _ref.collection('bookings').where('id', isEqualTo: bookingId);
      final _bookingSnap = await _bookingRef.get();

      ConfirmBooking _booking;

      if (_bookingSnap.docs.isNotEmpty) {
        _bookingSnap.docs.forEach((docSnap) {
          if (docSnap.exists) {
            _booking = ConfirmBooking.fromJson(docSnap.data());
          }
        });
      }

      if (_booking != null) {
        // final _userRef = _booking.userRef;
        final _hotelRef = _booking.hotelRef;

        // final _userSnap = await _userRef.get();
        final _hotelSnap = await _hotelRef.get();

        if (_hotelSnap.exists) {
          // final _appUser = AppUser.fromJson(_userSnap.data());
          final _hotel = Hotel.fromJson(_hotelSnap.data());

          if (_booking.isAccepted && !_booking.isDeclined) {
            _openBookingAcceptScreen(_booking, _hotel);
          } else {
            _openBookingDeclineScreen(_booking, _hotel);
          }
        }
      }
      print('Success: Opening accept-decline screen');
    } catch (e) {
      print(e);
      print('Error!!!: Opening accept-decline screen');
    }
  }

  // navigate to booking accept screen
  _openBookingAcceptScreen(final ConfirmBooking booking, final Hotel hotel) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingAcceptedScreen(booking, hotel),
      ),
    );
  }

  // navigate to booking decline screen
  _openBookingDeclineScreen(final ConfirmBooking booking, final Hotel hotel) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingDeclinedScreen(booking, hotel),
      ),
    );
  }

  // navigate to payment screenshot screen
  _openPaymentScreenshotScreen(final String bookingId) async {
    try {
      final _bookingRef =
          _ref.collection('bookings').where('id', isEqualTo: bookingId);
      final _bookingSnap = await _bookingRef.get();

      ConfirmBooking _booking;

      if (_bookingSnap.docs.isNotEmpty) {
        _bookingSnap.docs.forEach((docSnap) {
          if (docSnap.exists) {
            _booking = ConfirmBooking.fromJson(docSnap.data());
          }
        });
      }

      if (_booking != null) {
        final _userRef = _booking.userRef;
        final _hotelRef = _booking.hotelRef;

        final _userSnap = await _userRef.get();
        final _hotelSnap = await _hotelRef.get();

        if (_userSnap.exists && _hotelSnap.exists) {
          final _appUser = AppUser.fromJson(_userSnap.data());
          final _hotel = Hotel.fromJson(_hotelSnap.data());

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PaymentScreenshotScreen(
                _booking,
                _hotel,
                _appUser,
                false,
              ),
            ),
          );
        }
        print('Success: Opening payment ss screen');
      }
    } catch (e) {
      print(e);
      print('Error!!! Opening payment ss screen');
    }
  }
}
