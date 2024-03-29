import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motel/enums/booking_for_type.dart';

class ConfirmBooking {
  String bookingId;
  final DocumentReference userRef;
  final DocumentReference hotelRef;
  final DocumentReference tourRef;
  final DocumentReference vehicleRef;
  final int issueDate;
  final int total;
  final String ownerId;
  final bool isAccepted;
  final bool isDeclined;
  final String declineText;
  final List<dynamic> screenshots;
  final int checkInDate;
  final int checkOutDate;
  final List<dynamic> rooms;
  final int nights;
  final BookingForType type;

  ConfirmBooking({
    this.bookingId,
    this.userRef,
    this.issueDate,
    this.hotelRef,
    this.tourRef,
    this.vehicleRef,
    this.total,
    this.ownerId,
    this.isAccepted,
    this.isDeclined,
    this.declineText,
    this.screenshots,
    this.checkInDate,
    this.checkOutDate,
    this.rooms,
    this.nights,
    this.type,
  });

  static ConfirmBooking fromJson(final Map<String, dynamic> data) {
    if (data['type'] == 1) {
      return ConfirmTourBooking.fromJson(data);
    }
    if (data['type'] == 2) {
      return ConfirmVehicleBooking.fromJson(data);
    }
    return ConfirmHotelBooking.fromJson(data);
  }
}

class ConfirmHotelBooking extends ConfirmBooking {
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
  final String declineText;
  final List<dynamic> screenshots;
  final BookingForType type;

  ConfirmHotelBooking({
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
    this.declineText,
    this.screenshots,
    this.type,
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
      'type': 0,
    };
  }

  static ConfirmHotelBooking fromJson(final Map<String, dynamic> data) {
    return ConfirmHotelBooking(
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
      declineText: data['decline_text'] ?? '',
      screenshots: data['screenshots'] ?? [],
      type: BookingForType.hotel,
    );
  }
}

class ConfirmTourBooking extends ConfirmBooking {
  String bookingId;
  final DocumentReference tourRef;
  final DocumentReference userRef;
  final int issueDate;
  final int total;
  final int males;
  final int females;
  final int kids;
  final String ownerId;
  final bool isAccepted;
  final bool isDeclined;
  final String declineText;
  final List<dynamic> screenshots;
  final BookingForType type;
  final int tourDate;

  ConfirmTourBooking({
    this.bookingId,
    this.tourRef,
    this.userRef,
    this.issueDate,
    this.total,
    this.males,
    this.females,
    this.kids,
    this.ownerId,
    this.isAccepted,
    this.isDeclined,
    this.declineText,
    this.screenshots,
    this.type,
    this.tourDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': bookingId,
      'tour_ref': tourRef,
      'user_ref': userRef,
      'issue_date': issueDate,
      'total': total,
      'males': males,
      'females': females,
      'kids': kids,
      'owner_id': ownerId,
      'is_seen': isAccepted,
      'is_contacted': isDeclined,
      'type': 1,
      'tour_date': tourDate,
    };
  }

  static ConfirmTourBooking fromJson(final Map<String, dynamic> data) {
    return ConfirmTourBooking(
      bookingId: data['id'] ?? '',
      tourRef: data['tour_ref'] ?? '',
      userRef: data['user_ref'] ?? '',
      issueDate: data['issue_date'] ?? DateTime.now().millisecondsSinceEpoch,
      total: data['total'] ?? 0,
      males: data['males'] ?? 0,
      females: data['females'] ?? 0,
      kids: data['kids'] ?? 0,
      ownerId: data['owner_id'] ?? '',
      isAccepted: data['is_accepted'] ?? false,
      isDeclined: data['is_declined'] ?? false,
      declineText: data['decline_text'] ?? '',
      screenshots: data['screenshots'] ?? [],
      type: BookingForType.tour,
      tourDate: data['tour_date'],
    );
  }
}

class ConfirmVehicleBooking extends ConfirmBooking {
  String bookingId;
  final DocumentReference vehicleRef;
  final DocumentReference userRef;
  final int issueDate;
  final int total;
  final int males;
  final int females;
  final int kids;
  final int days;
  final String ownerId;
  final bool isAccepted;
  final bool isDeclined;
  final String declineText;
  final List<dynamic> screenshots;
  final BookingForType type;

  ConfirmVehicleBooking({
    this.bookingId,
    this.vehicleRef,
    this.userRef,
    this.issueDate,
    this.days,
    this.total,
    this.males,
    this.females,
    this.kids,
    this.ownerId,
    this.isAccepted,
    this.isDeclined,
    this.declineText,
    this.screenshots,
    this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': bookingId,
      'vehicle_ref': vehicleRef,
      'days': days,
      'user_ref': userRef,
      'issue_date': issueDate,
      'total': total,
      'males': males,
      'females': females,
      'kids': kids,
      'owner_id': ownerId,
      'is_seen': isAccepted,
      'is_contacted': isDeclined,
      'type': 2,
    };
  }

  static ConfirmVehicleBooking fromJson(final Map<String, dynamic> data) {
    return ConfirmVehicleBooking(
      bookingId: data['id'] ?? '',
      vehicleRef: data['vehicle_ref'] ?? '',
      days: data['days'] ?? 1,
      userRef: data['user_ref'] ?? '',
      issueDate: data['issue_date'] ?? DateTime.now().millisecondsSinceEpoch,
      total: data['total'] ?? 0,
      males: data['males'] ?? 0,
      females: data['females'] ?? 0,
      kids: data['kids'] ?? 0,
      ownerId: data['owner_id'] ?? '',
      isAccepted: data['is_accepted'] ?? false,
      isDeclined: data['is_declined'] ?? false,
      declineText: data['decline_text'] ?? '',
      screenshots: data['screenshots'] ?? [],
      type: BookingForType.vehicle,
    );
  }
}
