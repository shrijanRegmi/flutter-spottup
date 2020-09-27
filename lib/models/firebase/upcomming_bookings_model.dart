import 'package:cloud_firestore/cloud_firestore.dart';

class UpcomingBooking {
  final DocumentReference hotelRef;
  final int checkIn;
  final int checkOut;
  final int issueDate;
  UpcomingBooking({this.hotelRef, this.checkIn, this.checkOut, this.issueDate});

  Map<String, dynamic> toJson() {
    return {
      'hotel_ref': hotelRef,
      'check_in': checkIn,
      'check_out': checkOut,
      'issue_date': issueDate,
    };
  }

  static UpcomingBooking fromJson(Map<String, dynamic> data) {
    return UpcomingBooking(
      hotelRef: data['hotel_ref'] ?? '',
      checkIn: data['check_in'] ?? DateTime.now().millisecondsSinceEpoch,
      checkOut: data['check_out'] ?? DateTime.now().millisecondsSinceEpoch,
      issueDate: data['issue_date'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }
}
