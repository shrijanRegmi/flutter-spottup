import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motel/enums/notification_type.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/notification_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/views/screens/home/payment_screenshot_screen.dart';
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

    return GestureDetector(
      onTap: () {
        if (!notification.isRead) {
          readNotif(_appUser.uid, notification.id);
        }
        onPressedNotification(notification, _bookingsList);
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => PaymentScreenshotScreen(
        //       ConfirmBooking(),
        //       Hotel(),
        //       AppUser(),
        //     ),
        //   ),
        // );
      },
      child: Container(
        color: notification.isRead
            ? Colors.transparent
            : Colors.blue.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              _hotelImgBuilder(notification.hotel, notification.user),
              SizedBox(
                width: 10.0,
              ),
              _detailsBuilder(notification.hotel, _appUser, notification.user),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hotelImgBuilder(final Hotel hotel, final AppUser user) {
    return notification.type != NotificationType.bookingReceived
        ? hotel.dp == null
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
                      hotel.dp,
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
      final Hotel hotel, final AppUser appUser, final AppUser user) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getNotifTitle(hotel, appUser, user),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  _getNotifDetails(hotel, appUser, user),
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

  String _getNotifTitle(Hotel hotel, AppUser appUser, AppUser user) {
    if (notification.admin) {
      switch (notification.type) {
        case NotificationType.bookingReceived:
          return '${hotel.name} received a booking';
          break;
        case NotificationType.accepted:
          return "${hotel.name} accepted ${user.firstName} ${user.lastName}'s booking";
          break;
        case NotificationType.declined:
          return "${hotel.name} declined ${user.firstName} ${user.lastName}'s booking";
          break;
        default:
          return "${hotel.name} accepted ${user.firstName} ${user.lastName}'s booking";
      }
    } else {
      switch (notification.type) {
        case NotificationType.bookingReceived:
          return 'Congratulations, ${hotel.name} is booked by ${user.firstName} ${user.lastName}';
          break;
        case NotificationType.accepted:
          return 'Congratulations, your booking of ${hotel.name} was accepted.';
          break;
        case NotificationType.declined:
          return 'Sorry, your booking of ${hotel.name} was declined.';
          break;
        default:
          return 'Congratulations, your booking of ${hotel.name} was accepted.';
      }
    }
  }

  String _getNotifDetails(Hotel hotel, AppUser appUser, AppUser user) {
    if (appUser.admin) {
      switch (notification.type) {
        case NotificationType.bookingReceived:
          return '${user.firstName} ${user.lastName} booked ${hotel.name}';
          break;
        case NotificationType.accepted:
          return "${hotel.name} decided to accept ${user.firstName} ${user.lastName}'s booking";
          break;
        case NotificationType.declined:
          return "${hotel.name} decided to decline ${user.firstName} ${user.lastName}'s booking";
          break;
        default:
          return "${hotel.name} decided to accept ${user.firstName} ${user.lastName}'s booking";
      }
    } else {
      switch (notification.type) {
        case NotificationType.bookingReceived:
          return '${user.firstName} ${user.lastName} just booked ${hotel.name}';
          break;
        case NotificationType.accepted:
          return '${hotel.name} accepted your booking. Tap for more details.';
          break;
        case NotificationType.declined:
          return '${hotel.name} declined your booking. Tap to know why.';
          break;
        default:
          return '${hotel.name} accepted your booking. Tap for more details.';
      }
    }
  }
}
