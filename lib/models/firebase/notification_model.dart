import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motel/enums/notification_type.dart';

class AppNotification {
  final String id;
  final DocumentReference hotelRef;
  final NotificationType type;
  final bool isRead;
  final int lastUpdated;

  AppNotification({
    this.id,
    this.hotelRef,
    this.type,
    this.isRead,
    this.lastUpdated,
  });

  static AppNotification fromJson(final Map<String, dynamic> data) {
    return AppNotification(
      id: data['id'],
      hotelRef: data['hotel_ref'],
      isRead: data['is_read'] ?? false,
      lastUpdated:
          data['last_updated'] ?? DateTime.now().millisecondsSinceEpoch,
      type: _gettype(data['type'] ?? 0),
    );
  }
}

NotificationType _gettype(final type) {
  switch (type) {
    case 0:
      return NotificationType.accepted;
      break;
    case 1:
      return NotificationType.declined;
      break;
    case 2:
      return NotificationType.bookingReceived;
      break;
    default:
      return NotificationType.accepted;
      break;
  }
}
