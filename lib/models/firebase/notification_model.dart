import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  final String id;
  final DocumentReference hotelRef;
  final bool isAccepted;
  final bool isRead;
  final int lastUpdated;

  AppNotification(
      {this.id, this.hotelRef, this.isAccepted, this.isRead, this.lastUpdated});

  static AppNotification fromJson(final Map<String, dynamic> data) {
    return AppNotification(
      id: data['id'],
      hotelRef: data['hotel_ref'],
      isAccepted: data['is_accepted'] ?? false,
      isRead: data['is_read'] ?? false,
      lastUpdated:
          data['last_updated'] ?? DateTime.now().millisecondsSinceEpoch,
    );
  }
}
