import 'package:flutter/material.dart';
import 'package:image_viewer/image_viewer.dart';
import 'package:motel/helpers/date_helper.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/payment_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/viewmodels/payment_ss_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/widgets/hotel_view_widgets/hotel_photos_item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class PaymentScreenshotScreen extends StatelessWidget {
  final ConfirmHotelBooking booking;
  final Hotel hotel;
  final AppUser user;
  final bool admin;
  PaymentScreenshotScreen(
    this.booking,
    this.hotel,
    this.user,
    this.admin,
  );

  @override
  Widget build(BuildContext context) {
    return VmProvider<PaymentSsVm>(
      vm: PaymentSsVm(),
      onInit: (vm) => vm.onInit(user),
      builder: (context, vm, appUser) {
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
                                      height: 50.0,
                                    ),
                                    if (user.invitationFrom != null &&
                                        user.invitationFrom.bookingId ==
                                            booking.bookingId &&
                                        admin)
                                      _invitationFromBuilder(context, vm),
                                    if (user.invitationFrom != null &&
                                        user.invitationFrom.bookingId ==
                                            booking.bookingId &&
                                        admin)
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
      },
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
          'Hotel Name: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
        Text(
          hotel.name,
        ),
        if (booking.rooms.isNotEmpty)
          SizedBox(
            height: 20.0,
          ),
        if (booking.rooms.isNotEmpty)
          Text(
            'Rooms: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
        ..._getString(),
        SizedBox(
          height: 20.0,
        ),
        Text(
          'Hotel Id: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
        Text(hotel.id),
        SizedBox(
          height: 20.0,
        ),
        Text(
          'Check In - Check Out',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
        Text(
          '${DateHelper().getFormattedDate(booking.checkInDate)} - ${DateHelper().getFormattedDate(booking.checkOutDate)}',
        ),
      ],
    );
  }

  List<Widget> _getString() {
    List<Widget> _list = [];
    for (final room in booking.rooms) {
      _list.add(
        Text('$room'),
      );
    }
    return _list;
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

  Widget _invitationFromBuilder(
      final BuildContext context, final PaymentSsVm vm) {
    final _paymentConfig = Provider.of<Payment>(context);

    final _ref = FirebaseFirestore.instance;
    return StreamBuilder<AppUser>(
      stream: _ref
          .collection('users')
          .doc(user.invitationFrom?.uid)
          .snapshots()
          .map((event) => AppUser.fromJson(event.data())),
      builder: (BuildContext context, AsyncSnapshot<AppUser> snapshot) {
        if (snapshot.hasData) {
          final _user = snapshot.data;

          return Container(
            child: Column(
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16.0,
                      fontFamily: 'Nunito',
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(
                        text:
                            'The booking is made from an invitation link which was shared by ',
                      ),
                      TextSpan(
                        text:
                            'username: ${_user.firstName} ${_user.lastName} | email: ${_user.email} | phone: ${_user.phone == '0' ? 'N/A' : _user.phone}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Please confirm so that the person will get ${_paymentConfig.percentage}% commission (Rs ${int.parse((_paymentConfig.percentage / 100 * booking.total).toStringAsFixed(0))}) of the total amount.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20.0,
                ),
                _acceptDeclineBuilder(context, vm, user.invitationFrom.uid),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget _acceptDeclineBuilder(
      final BuildContext context, final PaymentSsVm vm, final String uid) {
    final _paymentConfig = Provider.of<Payment>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: !vm.isConfirmed && !vm.isDeclined
          ? Row(
              children: [
                Expanded(
                  child: Center(
                    child: MaterialButton(
                      child: Text('Confirm'),
                      color: Color(0xff45ad90),
                      minWidth: 180.0,
                      textColor: Colors.white,
                      onPressed: () => vm.confirmToPay(
                        user,
                        uid,
                        int.parse(
                          (_paymentConfig.percentage / 100 * booking.total)
                              .toStringAsFixed(0),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Center(
                    child: MaterialButton(
                      child: Text('Decline'),
                      color: Colors.red,
                      minWidth: 180.0,
                      textColor: Colors.white,
                      onPressed: () => vm.declineToPay(user),
                    ),
                  ),
                ),
              ],
            )
          : vm.isConfirmed && !vm.isDeclined
              ? MaterialButton(
                  child: Text('Confirmed'),
                  color: Color(0xff45ad90),
                  minWidth: 180.0,
                  textColor: Colors.white,
                  onPressed: () {},
                )
              : MaterialButton(
                  child: Text('Declined'),
                  color: Colors.red,
                  minWidth: 180.0,
                  textColor: Colors.white,
                  onPressed: () {},
                ),
    );
  }
}
