import 'package:cloud_firestore/cloud_firestore.dart';

class UpcomingBooking {
  final DocumentReference hotelRef;
  final String checkIn;
  final String checkOut;
  UpcomingBooking({this.hotelRef, this.checkIn, this.checkOut});

  Map<String, dynamic> toJson() {
    return {
      'hotel_ref': hotelRef,
      'check_in': checkIn,
      'check_out': checkOut,
    };
  }

  static UpcomingBooking fromJson(Map<String, dynamic> data) {
    return UpcomingBooking(
      hotelRef: data['hotel_ref'] ?? '',
      checkIn: data['check_in'] ?? '',
      checkOut: data['check_out'] ?? '',
    );
  }
}
