import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motel/enums/notification_type.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/notification_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/hotel_provider.dart';
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
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (_) => OpenBookingItemScreen(
        //       _booking,
        //       _appUser,
        //       _hotel,
        //       bookingType: bookingType,
        //     ),
        //   ),
        // );
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
          child: Row(
            children: [
              _hotelImgBuilder(notification.hotel, notification.user),
              SizedBox(
                width: 10.0,
              ),
              _detailsBuilder(notification.hotel, notification.user),
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

  Widget _detailsBuilder(final Hotel hotel, final AppUser user) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.type == NotificationType.accepted
                      ? 'Congratulations, your booking of ${hotel.name} was accepted.'
                      : notification.type == NotificationType.bookingReceived
                          ? '${hotel.name} is booked by ${user.firstName} ${user.lastName}'
                          : 'Sorry, your booking of ${hotel.name} was declined.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  notification.type == NotificationType.accepted
                      ? '${hotel.name} accepted your booking. Tap for more details.'
                      : notification.type == NotificationType.bookingReceived
                          ? '${user.firstName} ${user.lastName} just booked ${hotel.name}'
                          : '${hotel.name} declined your booking. Tap to know why.',
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
          Icon(
            Icons.arrow_forward_ios,
            size: 20.0,
          ),
        ],
      ),
    );
  }
}
