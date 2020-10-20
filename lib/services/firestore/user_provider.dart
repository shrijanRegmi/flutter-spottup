import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/models/firebase/last_search_model.dart';
import 'package:motel/models/firebase/notification_model.dart';
import 'package:motel/models/firebase/payment_model.dart';
import 'package:motel/models/firebase/upcomming_bookings_model.dart';
import 'package:motel/models/firebase/user_model.dart';

class UserProvider {
  final String uid;
  final DocumentReference appUserRef;
  UserProvider({this.uid, this.appUserRef});

  final _ref = Firestore.instance;

  // send user to firestore
  Future sendUserToFirestore(AppUser appUser, String uid) async {
    try {
      final _userRef = _ref.collection('users').document(uid);

      print('Success: Sending user data to firestore');
      return await _userRef.setData(appUser.toJson());
    } catch (e) {
      print(e);
      print('Error!!!: Sending user data to firestore');
      return null;
    }
  }

  // update user data
  Future updateUserData(final Map<String, dynamic> data) async {
    try {
      await _ref.collection('users').document(uid).updateData(data);
      print('Success: Updating user data $data');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Updating user data $data');
      return null;
    }
  }

  // save last search
  Future saveLastSearch(final LastSearch lastSearch) async {
    try {
      final _lastSearchRef =
          _ref.collection('users').document(uid).collection('last_search');

      final _values = await _lastSearchRef
          .limit(5)
          .orderBy('last_updated', descending: true)
          .getDocuments();
      var _result;
      bool _alreadyExists = false;
      if (_values.documents.isNotEmpty) {
        for (final doc in _values.documents) {
          final _hotelRef = doc.data['hotel_ref'];
          _alreadyExists = lastSearch.hotelRef.path == _hotelRef.path;
          if (_alreadyExists) {
            break;
          }
        }
      }
      if (!_alreadyExists) {
        _result = await _lastSearchRef.add(lastSearch.toJson());
        print('Success: Saving last search');
      }
      return _result;
    } catch (e) {
      print(e);
      print('Error!!!: Saving last search');
      return null;
    }
  }

  // clear all the last searches
  Future clearSearch() async {
    try {
      final _lastSearchRef = await _ref
          .collection('users')
          .document(uid)
          .collection('last_search')
          .getDocuments();
      if (_lastSearchRef.documents.isNotEmpty) {
        for (final doc in _lastSearchRef.documents) {
          doc.reference.delete();
        }
      }
      print('Success: Clearing last search');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Clearing last search');
      return null;
    }
  }

  // confirm hotel booking
  Future confirmHotelBooking(final ConfirmHotelBooking booking) async {
    try {
      final _bookingRef = _ref.collection('bookings').document();
      final _upcommingRef =
          _ref.collection('users').document(uid).collection('upcomming');

      booking.bookingId = _bookingRef.documentID;

      var _result = await _bookingRef.setData(booking.toJson());
      final _upcoming = UpcomingBooking(
        hotelRef: booking.hotelRef,
        checkIn: booking.checkInDate,
        checkOut: booking.checkOutDate,
        issueDate: DateTime.now().millisecondsSinceEpoch,
      );

      _result = await _upcommingRef.add(_upcoming.toJson());

      print('Success: Sending booking details to firestore');
      return _result;
    } catch (e) {
      print(e);
      print('Error!!!: Sending booking details to firestore');
      return null;
    }
  }

  Future confirmTourBooking(final ConfirmTourBooking booking) async {
    try {
      final _bookingRef = _ref.collection('bookings').document();
      booking.bookingId = _bookingRef.documentID;

      var _result = await _bookingRef.setData(booking.toJson());
      print('Success: Sending booking details to firestore');
      return _result;
    } catch (e) {
      print(e);
      print('Error!!!: Sending booking details to firestore');
      return null;
    }
  }

  Future confirmVehicleBooking(final ConfirmVehicleBooking booking) async {
    try {
      final _bookingRef = _ref.collection('bookings').document();

      booking.bookingId = _bookingRef.documentID;

      var _result = await _bookingRef.setData(booking.toJson());
      print('Success: Sending booking details to firestore');
      return _result;
    } catch (e) {
      print(e);
      print('Error!!!: Sending booking details to firestore');
      return null;
    }
  }

  // read notification
  readNotification(final String notifId) async {
    try {
      final _notifRef = _ref
          .collection('users')
          .document(uid)
          .collection('notifications')
          .document(notifId);
      await _notifRef.updateData({'is_read': true});
      print('Success: reading notification');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: reading notification');
      return null;
    }
  }

  // user from firebase
  AppUser _appUserFromFirebase(DocumentSnapshot userSnap) {
    return AppUser.fromJson(userSnap.data);
  }

  // upcomming bookings from firebase
  List<UpcomingBooking> _upcomingBookingFromFirebase(QuerySnapshot colSnap) {
    return colSnap.documents
        .map((doc) => UpcomingBooking.fromJson(doc.data))
        .toList();
  }

  // notifications from firebase
  List<AppNotification> _notificationFromFirebase(QuerySnapshot colSnap) {
    return colSnap.documents
        .map((doc) => AppNotification.fromJson(doc.data))
        .toList();
  }

  // payment from firebase
  Payment _paymentFromFirebase(DocumentSnapshot docSnap) {
    return Payment.fromJson(docSnap.data);
  }

  // stream of user
  Stream<AppUser> get appUser {
    return _ref
        .collection('users')
        .document(uid)
        .snapshots()
        .map(_appUserFromFirebase);
  }

  // stream of user from reference
  Stream<AppUser> get appUserFromRef {
    return appUserRef.snapshots().map(_appUserFromFirebase);
  }

  // stream of list of upcoming bookings
  Stream<List<UpcomingBooking>> get upcomingBookings {
    return _ref
        .collection('users')
        .document(uid)
        .collection('upcomming')
        .orderBy('issue_date', descending: true)
        .limit(50)
        .snapshots()
        .map(_upcomingBookingFromFirebase);
  }

  // stream of list of notifications
  Stream<List<AppNotification>> get notificationsList {
    return _ref
        .collection('users')
        .document(uid)
        .collection('notifications')
        .orderBy('last_updated', descending: true)
        .limit(50)
        .snapshots()
        .map(_notificationFromFirebase);
  }

  // stream of user
  Stream<Payment> get paymentDetails {
    return _ref
        .collection('configs')
        .document('payment')
        .snapshots()
        .map(_paymentFromFirebase);
  }
}
