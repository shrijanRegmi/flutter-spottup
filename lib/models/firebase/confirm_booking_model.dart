import 'package:cloud_firestore/cloud_firestore.dart';

class ConfirmBooking {
  final DocumentReference hotelRef;
  final DocumentReference userRef;
  final int checkInDate;
  final int checkOutDate;
  final List<dynamic> rooms;
  final int issueDate;
  final int total;
  final int nights;
  final String ownerId;
  final bool isSeen;
  final bool isContacted;

  ConfirmBooking({
    this.hotelRef,
    this.userRef,
    this.checkInDate,
    this.checkOutDate,
    this.rooms,
    this.issueDate,
    this.total,
    this.nights,
    this.ownerId,
    this.isSeen,
    this.isContacted,
  });

  Map<String, dynamic> toJson() {
    return {
      'hotel_ref': hotelRef,
      'user_ref': userRef,
      'check_in': checkInDate,
      'check_out': checkOutDate,
      'rooms': rooms,
      'issue_date': issueDate,
      'total': total,
      'nights': nights,
      'owner_id': ownerId,
      'is_seen': isSeen,
      'is_contacted': isContacted,
    };
  }

  static ConfirmBooking fromJson(final Map<String, dynamic> data) {
    return ConfirmBooking(
      hotelRef: data['hotel_ref'] ?? '',
      userRef: data['user_ref'] ?? '',
      checkInDate: data['check_in'] ?? DateTime.now().millisecondsSinceEpoch,
      checkOutDate: data['check_out'] ?? DateTime.now().millisecondsSinceEpoch,
      rooms: data['rooms'] ?? [],
      issueDate: data['issue_date'] ?? DateTime.now().millisecondsSinceEpoch,
      total: data['total'] ?? 0,
      nights: data['nights'] ?? 0,
      ownerId: data['owner_id'] ?? '',
      isSeen: data['is_seen'] ?? false,
      isContacted: data['is_contacted'] ?? false,
    );
  }
}
