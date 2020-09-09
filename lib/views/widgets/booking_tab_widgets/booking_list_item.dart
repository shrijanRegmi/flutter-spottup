import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motel/enums/booking_type.dart';
import 'package:motel/helpers/date_helper.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/hotel_provider.dart';
import 'package:motel/services/firestore/user_provider.dart';
import 'package:motel/views/screens/home/open_booking_item_screen.dart';

class BookingListItem extends StatelessWidget {
  final ConfirmBooking _booking;
  final BookingType bookingType;
  BookingListItem(this._booking, this.bookingType);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Hotel>(
      stream: HotelProvider(hotelRef: _booking.hotelRef).hotelFromRef,
      builder: (context, hotelSnap) {
        if (hotelSnap.hasData) {
          final _hotel = hotelSnap.data;
          return StreamBuilder<AppUser>(
            stream: UserProvider(appUserRef: _booking.userRef).appUserFromRef,
            builder: (context, appUserSnap) {
              if (appUserSnap.hasData) {
                final _appUser = appUserSnap.data;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OpenBookingItemScreen(
                          _booking,
                          _appUser,
                          _hotel,
                          bookingType: bookingType,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        children: [
                          _userImgBuilder(_appUser),
                          SizedBox(
                            width: 10.0,
                          ),
                          _detailsBuilder(_hotel, _appUser),
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
        return Container();
      },
    );
  }

  Widget _userImgBuilder(final AppUser appUser) {
    return appUser.photoUrl == null
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
                    appUser.photoUrl,
                  ),
                  fit: BoxFit.cover),
            ),
          );
  }

  Widget _detailsBuilder(final Hotel hotel, final AppUser appUser) {
    final _formattedCheckIn =
        DateHelper().getFormattedDate(_booking.checkInDate) ?? '';
    final _formattedCheckOut =
        DateHelper().getFormattedDate(_booking.checkOutDate) ?? '';

    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hotel.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
              Text(
                '${appUser.firstName} ${appUser.lastName}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
              Text(
                '$_formattedCheckIn - $_formattedCheckOut',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                ),
              ),
            ],
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
