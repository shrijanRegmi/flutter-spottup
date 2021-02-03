import 'package:motel/enums/booking_for_type.dart';
import 'package:motel/enums/notification_type.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/tour_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/models/firebase/vehicle_model.dart';

class AppNotification {
  final String id;
  final service;
  final AppUser user;
  final NotificationType type;
  final BookingForType bookingFor;
  final bool isRead;
  final int lastUpdated;
  final String bookingId;
  final bool admin;
  final String amount;
  final String easyPaisaNum;
  final String bankAccountNum;

  AppNotification({
    this.id,
    this.service,
    this.user,
    this.type,
    this.bookingFor,
    this.isRead,
    this.lastUpdated,
    this.bookingId,
    this.admin,
    this.amount,
    this.easyPaisaNum,
    this.bankAccountNum,
  });

  static AppNotification fromJson(final Map<String, dynamic> data) {
    return AppNotification(
      id: data['id'],
      service: _getService(data['booking_for'], data),
      user: AppUser.fromJson(data['user_data']),
      isRead: data['is_read'] ?? false,
      lastUpdated:
          data['last_updated'] ?? DateTime.now().millisecondsSinceEpoch,
      type: _gettype(data['type'] ?? 0),
      bookingId: data['booking_id'] ?? '',
      admin: data['admin'] ?? false,
      amount: data['amount'],
      easyPaisaNum: data['easy_paisa'],
      bankAccountNum: data['bank_account_num'],
      bookingFor: _getBookingFortype(data['booking_for']),
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
    case 3:
      return NotificationType.paymentReceived;
      break;
    case 4:
      return NotificationType.withdraw;
      break;
    default:
      return NotificationType.accepted;
      break;
  }
}

BookingForType _getBookingFortype(final type) {
  switch (type) {
    case 0:
      return BookingForType.hotel;
      break;
    case 1:
      return BookingForType.tour;
      break;
    case 2:
      return BookingForType.vehicle;
      break;
    default:
      return BookingForType.none;
      break;
  }
}

_getService(final type, final data) {
  switch (type) {
    case 0:
      return Hotel.fromJson(data['hotel_data']);
      break;
    case 1:
      return Tour.fromJson(data['tour_data']);
      break;
    case 2:
      return Vehicle.fromJson(data['vehicle_data']);
      break;
    default:
      return null;
      break;
  }
}
