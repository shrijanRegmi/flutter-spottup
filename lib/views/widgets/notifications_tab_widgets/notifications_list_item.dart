import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motel/enums/booking_for_type.dart';
import 'package:motel/enums/notification_type.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/models/firebase/notification_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:provider/provider.dart';

class NotificationsListItem extends StatelessWidget {
  final AppNotification notification;
  final Function(
          AppNotification notification, List<ConfirmBooking> bookingsList)
      onPressedNotification;
  final Function(String uid, String notifId) readNotif;
  NotificationsListItem(
      this.notification, this.readNotif, this.onPressedNotification);

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    final _bookingsList = Provider.of<List<ConfirmBooking>>(context) ?? [];

    Widget _notifWidget;
    print(notification.bookingFor);
    switch (notification.bookingFor) {
      case BookingForType.hotel:
        _notifWidget = _hotelNotifBuilder(_appUser);
        break;
      case BookingForType.tour:
        _notifWidget = _tourNotifBuilder(_appUser);
        break;
      case BookingForType.vehicle:
        _notifWidget = _vehicleNotifBuilder(_appUser);
        break;
      default:
        _notifWidget = _hotelNotifBuilder(_appUser);
    }

    _notifWidget = _hotelNotifBuilder(_appUser);

    return GestureDetector(
      onTap: () {
        if (!notification.isRead) {
          readNotif(_appUser.uid, notification.id);
        }
        onPressedNotification(notification, _bookingsList);
      },
      child: Container(
        color: notification.isRead
            ? Colors.transparent
            : Colors.blue.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: _notifWidget,
        ),
      ),
    );
  }

  Widget _hotelNotifBuilder(final AppUser _appUser) {
    return Row(
      children: [
        _imgBuilder(notification.service, notification.user),
        SizedBox(
          width: 10.0,
        ),
        _detailsBuilder(notification.service, _appUser, notification.user),
      ],
    );
  }

  Widget _tourNotifBuilder(final AppUser _appUser) {
    return Row(
      children: [
        _imgBuilder(notification.service, notification.user),
        SizedBox(
          width: 10.0,
        ),
        _detailsBuilder(notification.service, _appUser, notification.user),
      ],
    );
  }

  Widget _vehicleNotifBuilder(final AppUser _appUser) {
    return Row(
      children: [
        _imgBuilder(notification.service, notification.user),
        SizedBox(
          width: 10.0,
        ),
        _detailsBuilder(notification.service, _appUser, notification.user),
      ],
    );
  }

  Widget _imgBuilder(final service, final AppUser user) {
    return notification.type != NotificationType.bookingReceived
        ? service.dp == null
            ? Container(
                width: 55.0,
                height: 55.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/svgs/upload_img.svg',
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                width: 55.0,
                height: 55.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      service.dp,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              )
        : user.photoUrl == null
            ? Container(
                width: 55.0,
                height: 55.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: SvgPicture.asset(
                  'assets/svgs/upload_img.svg',
                  fit: BoxFit.cover,
                ),
              )
            : Container(
                width: 55.0,
                height: 55.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      user.photoUrl,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              );
  }

  Widget _detailsBuilder(
      final service, final AppUser appUser, final AppUser user) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getNotifTitle(service, appUser, user),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  _getNotifDetails(service, appUser, user),
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          notification.admin
              ? Icon(
                  Icons.star,
                  size: 20.0,
                )
              : Icon(
                  Icons.arrow_forward_ios,
                  size: 20.0,
                ),
        ],
      ),
    );
  }

  String _getNotifTitle(final service, AppUser appUser, AppUser user) {
    if (notification.admin) {
      switch (notification.type) {
        case NotificationType.bookingReceived:
          return '${service.name} received a booking';
          break;
        case NotificationType.accepted:
          return "${service.name} accepted ${user.firstName} ${user.lastName}'s booking";
          break;
        case NotificationType.declined:
          return "${service.name} declined ${user.firstName} ${user.lastName}'s booking";
          break;
        case NotificationType.paymentReceived:
          return "Payment screenshots received from ${user.firstName} ${user.lastName}";
          break;
        default:
          return "${service.name} accepted ${user.firstName} ${user.lastName}'s booking";
      }
    } else {
      switch (notification.type) {
        case NotificationType.bookingReceived:
          return 'Congratulations, ${service.name} is booked by ${user.firstName} ${user.lastName}';
          break;
        case NotificationType.accepted:
          return 'Congratulations, your booking of ${service.name} was accepted.';
          break;
        case NotificationType.declined:
          return 'Sorry, your booking of ${service.name} was declined.';
          break;
        case NotificationType.paymentReceived:
          return "Payment screenshots received from ${user.firstName} ${user.lastName}";
          break;
        default:
          return 'Congratulations, your booking of ${service.name} was accepted.';
      }
    }
  }

  String _getNotifDetails(final service, AppUser appUser, AppUser user) {
    if (appUser.admin) {
      switch (notification.type) {
        case NotificationType.bookingReceived:
          return '${user.firstName} ${user.lastName} booked ${service.name}';
          break;
        case NotificationType.accepted:
          return "${service.name} decided to accept ${user.firstName} ${user.lastName}'s booking";
          break;
        case NotificationType.declined:
          return "${service.name} decided to decline ${user.firstName} ${user.lastName}'s booking";
          break;
        case NotificationType.paymentReceived:
          return "${user.firstName} ${user.lastName} submitted payment screenshots for ${service.name}";
          break;
        default:
          return "${service.name} decided to accept ${user.firstName} ${user.lastName}'s booking";
      }
    } else {
      switch (notification.type) {
        case NotificationType.bookingReceived:
          return '${user.firstName} ${user.lastName} just booked ${service.name}';
          break;
        case NotificationType.accepted:
          return '${service.name} accepted your booking. Tap for more details.';
          break;
        case NotificationType.declined:
          return '${service.name} declined your booking. Tap to know why.';
          break;
        case NotificationType.paymentReceived:
          return "${user.firstName} ${user.lastName} submitted payment screenshots for ${service.name}";
          break;
        default:
          return '${service.name} accepted your booking. Tap for more details.';
      }
    }
  }
}
