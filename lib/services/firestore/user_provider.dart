import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/last_search_model.dart';
import 'package:motel/models/firebase/upcomming_bookings_model.dart';
import 'package:motel/models/firebase/user_model.dart';

class UserProvider {
  final String uid;
  UserProvider({this.uid});

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
  Future confirmBooking(final ConfirmBooking booking) async {
    try {
      final _bookingRef = _ref.collection('bookings');
      final _upcommingRef =
          _ref.collection('users').document(uid).collection('upcomming');

      var _result = await _bookingRef.add(booking.toJson());
      final _upcoming = UpcomingBooking(
        hotelRef: booking.hotelRef,
        checkIn: booking.checkInDate,
        checkOut: booking.checkOutDate,
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

  // stream of user
  Stream<AppUser> get appUser {
    return _ref
        .collection('users')
        .document(uid)
        .snapshots()
        .map(_appUserFromFirebase);
  }

  // stream of list of upcoming bookings
  Stream<List<UpcomingBooking>> get upcomingBookings {
    return _ref.collection('users').document(uid).collection('upcomming').snapshots().map(_upcomingBookingFromFirebase);
  }
}
