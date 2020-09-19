import 'package:motel/enums/notification_type.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/user_model.dart';

class AppNotification {
  final String id;
  final Hotel hotel;
  final AppUser user;
  final NotificationType type;
  final bool isRead;
  final int lastUpdated;
  final String bookingId;
  final bool admin;

  AppNotification({
    this.id,
    this.hotel,
    this.user,
    this.type,
    this.isRead,
    this.lastUpdated,
    this.bookingId,
    this.admin,
  });

  static AppNotification fromJson(final Map<String, dynamic> data) {
    return AppNotification(
      id: data['id'],
      hotel: Hotel.fromJson(data['hotel_data']),
      user: AppUser.fromJson(data['user_data']),
      isRead: data['is_read'] ?? false,
      lastUpdated:
          data['last_updated'] ?? DateTime.now().millisecondsSinceEpoch,
      type: _gettype(data['type'] ?? 0),
      bookingId: data['booking_id'] ?? '',
      admin: data['admin'] ?? false,
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
