import 'package:cloud_firestore/cloud_firestore.dart';

class UpcomingBooking {
  final DocumentReference hotelRef;
  final int checkIn;
  final int checkOut;
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
      checkIn: data['check_in'] ?? 0,
      checkOut: data['check_out'] ?? 0,
    );
  }
}
