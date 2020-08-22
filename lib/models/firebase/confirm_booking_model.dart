import 'package:cloud_firestore/cloud_firestore.dart';

class ConfirmBooking {
  final DocumentReference hotelRef;
  final DocumentReference userRef;
  final String checkInDate;
  final String checkOutDate;
  final List<String> rooms;
  final String issueDate;
  final int total;
  final int nights;
  final Map<String, dynamic> userDetail;
  final String hotelName;

  ConfirmBooking({
    this.hotelRef,
    this.userRef,
    this.checkInDate,
    this.checkOutDate,
    this.rooms,
    this.issueDate,
    this.total,
    this.nights,
    this.userDetail,
    this.hotelName,
  });

  Map<String, dynamic> toJson() {
    return {
      'hotel_ref': hotelRef,
      'user_ref': userRef,
      'check_in': checkInDate,
      'check_out': checkOutDate,
      'rooms': rooms,
      'issueDate': issueDate,
      'total': total,
      'nights': nights,
      'user_detail': userDetail,
      'hotel_name': hotelName,
    };
  }
}
