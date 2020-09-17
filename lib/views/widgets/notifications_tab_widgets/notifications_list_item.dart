import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/notification_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/hotel_provider.dart';
import 'package:provider/provider.dart';

class NotificationsListItem extends StatelessWidget {
  final AppNotification notification;
  final Function(String uid, String notifId) readNotif;
  NotificationsListItem(this.notification, this.readNotif);

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return StreamBuilder<Hotel>(
      stream: HotelProvider(hotelRef: notification.hotelRef).hotelFromRef,
      builder: (context, hotelSnap) {
        if (hotelSnap.hasData) {
          final _hotel = hotelSnap.data;
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
              readNotif(_appUser.uid, notification.id);
            },
            child: Container(
              color: notification.isRead
                  ? Colors.transparent
                  : Colors.blue.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    _hotelImgBuilder(_hotel),
                    SizedBox(
                      width: 10.0,
                    ),
                    _detailsBuilder(_hotel),
                  ],
                ),
              ),
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _hotelImgBuilder(final Hotel hotel) {
    return hotel.dp == null
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
          );
  }

  Widget _detailsBuilder(final Hotel hotel) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.isAccepted
                      ? 'Congratulations, your booking of ${hotel.name} was accepted.'
                      : 'Sorry, your booking of ${hotel.name} was declined.',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  notification.isAccepted
                      ? '${hotel.name} accepted your booking. Tap for more details.'
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
