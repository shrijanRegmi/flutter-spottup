import 'package:cloud_firestore/cloud_firestore.dart';

class ConfirmBooking {
  String bookingId;
  final DocumentReference hotelRef;
  final DocumentReference userRef;
  final int checkInDate;
  final int checkOutDate;
  final List<dynamic> rooms;
  final int issueDate;
  final int total;
  final int nights;
  final String ownerId;
  final bool isAccepted;
  final bool isDeclined;

  ConfirmBooking({
    this.bookingId,
    this.hotelRef,
    this.userRef,
    this.checkInDate,
    this.checkOutDate,
    this.rooms,
    this.issueDate,
    this.total,
    this.nights,
    this.ownerId,
    this.isAccepted,
    this.isDeclined,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': bookingId,
      'hotel_ref': hotelRef,
      'user_ref': userRef,
      'check_in': checkInDate,
      'check_out': checkOutDate,
      'rooms': rooms,
      'issue_date': issueDate,
      'total': total,
      'nights': nights,
      'owner_id': ownerId,
      'is_seen': isAccepted,
      'is_contacted': isDeclined,
    };
  }

  static ConfirmBooking fromJson(final Map<String, dynamic> data) {
    return ConfirmBooking(
      bookingId: data['id'] ?? '',
      hotelRef: data['hotel_ref'] ?? '',
      userRef: data['user_ref'] ?? '',
      checkInDate: data['check_in'] ?? DateTime.now().millisecondsSinceEpoch,
      checkOutDate: data['check_out'] ?? DateTime.now().millisecondsSinceEpoch,
      rooms: data['rooms'] ?? [],
      issueDate: data['issue_date'] ?? DateTime.now().millisecondsSinceEpoch,
      total: data['total'] ?? 0,
      nights: data['nights'] ?? 0,
      ownerId: data['owner_id'] ?? '',
      isAccepted: data['is_accepted'] ?? false,
      isDeclined: data['is_declined'] ?? false,
    );
  }
}
