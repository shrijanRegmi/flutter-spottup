import 'package:flutter/material.dart';
import 'package:image_viewer/image_viewer.dart';
import 'package:motel/helpers/date_helper.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/models/firebase/tour_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/views/widgets/hotel_view_widgets/hotel_photos_item.dart';

class TourPaymentScreenshotScreen extends StatelessWidget {
  final ConfirmTourBooking booking;
  final Tour tour;
  final AppUser user;
  TourPaymentScreenshotScreen(this.booking, this.tour, this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - kToolbarHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _appbarBuilder(context),
                SizedBox(
                  height: 10.0,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _topSectionBuilder(),
                                SizedBox(
                                  height: 20.0,
                                ),
                                _hotelDetailBuilder(),
                                SizedBox(
                                  height: 20.0,
                                ),
                                _screenshotTextBuilder(),
                                SizedBox(
                                  height: 10.0,
                                ),
                                _screenshotsBuilder(),
                                SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appbarBuilder(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _topSectionBuilder() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _userDetailBuilder(),
        _issuedDateBuilder(),
      ],
    );
  }

  Widget _userDetailBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${user.firstName} ${user.lastName}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22.0,
          ),
        ),
        Text(
          user.email,
        ),
        Text(
          '${user.phone}',
        ),
      ],
    );
  }

  Widget _issuedDateBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          'Booking Date :',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
        Text(DateHelper().getFormattedDate(booking.issueDate)),
      ],
    );
  }

  Widget _hotelDetailBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Tour Package Name: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
        Text(
          tour.name,
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          'Number of males: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
        Text(
          '${booking.males}',
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          'Number of females: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
        Text(
          '${booking.females}',
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          'Number of kids: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
        Text(
          '${booking.kids}',
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          'Tour Id: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
        Text(tour.id),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  Widget _screenshotTextBuilder() {
    return Text(
      'Screenshots',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 16.0,
      ),
    );
  }

  Widget _screenshotsBuilder() {
    return Container(
      height: 120.0,
      child: ListView.builder(
        itemCount: booking.screenshots.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () async {
              try {
                await ImageViewer.showImageSlider(
                  images: _getStringList(booking.screenshots),
                  startingPosition: index,
                );
              } catch (e) {
                print(e);
                print('Error!!!');
              }
            },
            child: HotelPhotosItem(booking.screenshots[index]),
          );
        },
      ),
    );
  }

  List<String> _getStringList(final List<dynamic> screenshots) {
    List<String> _list = [];
    screenshots.forEach((element) {
      _list.add(element.toString());
    });
    return _list;
  }
}
