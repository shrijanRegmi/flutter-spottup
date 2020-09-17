import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:motel/enums/booking_type.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/views/screens/home/open_booking_item_screen.dart';

class FirebaseMessagingProvider {
  final String uid;
  final BuildContext context;
  FirebaseMessagingProvider({this.uid, this.context});

  final _ref = Firestore.instance;
  final _firebaseMessaging = FirebaseMessaging();

  Future configureMessaging() async {
    _firebaseMessaging.configure(
      onLaunch: (message) {
        final _data = message['data'];
        final _screen = _data['screen'];
        final _id = _data['id'];

        switch (_screen) {
          case 'booking-received-screen':
            return _openBookingScreen(_id);
            break;
          default:
        }
        return null;
      },
      onResume: (message) {
        final _data = message['data'];
        final _screen = _data['screen'];
        final _id = _data['id'];

        switch (_screen) {
          case 'booking-received-screen':
            return _openBookingScreen(_id);
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
          .document(uid)
          .collection('devices')
          .document(_androidInfo.androidId);

      final _token = await _firebaseMessaging.getToken();
      print('Success: saving device info to firestore');
      await _deviceRef.setData({'token': _token});
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!! saving device info to firestore');
      return null;
    }
  }

  _openBookingScreen(final String bookingId) async {
    try {
      final _bookingRef =
          _ref.collection('bookings').where('id', isEqualTo: bookingId);
      final _bookingSnap = await _bookingRef.getDocuments();

      ConfirmBooking _booking;

      if (_bookingSnap.documents.isNotEmpty) {
        _bookingSnap.documents.forEach((docSnap) {
          if (docSnap.exists) {
            _booking = ConfirmBooking.fromJson(docSnap.data);
          }
        });
      }

      if (_booking != null) {
        final _userRef = _booking.userRef;
        final _hotelRef = _booking.hotelRef;

        final _userSnap = await _userRef.get();
        final _hotelSnap = await _hotelRef.get();

        if (_userSnap.exists && _hotelSnap.exists) {
          final _appUser = AppUser.fromJson(_userSnap.data);
          final _hotel = Hotel.fromJson(_hotelSnap.data);

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
}
