import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:motel/helpers/date_helper.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/viewmodels/booking_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';

class ProceedBookingScreen extends StatelessWidget {
  final Hotel hotel;
  final int days;
  final int checkIn;
  final int checkOut;
  final String name;
  final String phone;
  final List<SelectedRoom> rooms;
  ProceedBookingScreen({
    this.hotel,
    this.days,
    this.checkIn,
    this.checkOut,
    this.name,
    this.phone,
    this.rooms,
  });

  @override
  Widget build(BuildContext context) {
    return VmProvider<BookVm>(
      vm: BookVm(context: context),
      builder: (context, vm, appUser) {
        return Scaffold(
          key: vm.scaffoldKey,
          body: SafeArea(
            child: vm.isProcessing
                ? Center(
                    child: Lottie.asset('assets/lottie/loading.json'),
                  )
                : SingleChildScrollView(
                    child: Container(
                      height:
                          MediaQuery.of(context).size.height - kToolbarHeight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _appbarBuilder(context),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          _topSectionBuilder(appUser),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          _hotelDetailBuilder(),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: <Widget>[
                                      _totalPriceBuilder(),
                                      SizedBox(
                                        height: 20.0,
                                      ),
                                      RoundedBtn(
                                        title: 'Confirm Booking',
                                        onPressed: () {
                                          int _total = 0;

                                          if (rooms.isNotEmpty) {
                                            for (final room in rooms) {
                                              _total += room.price;
                                            }
                                          } else {
                                            _total = hotel.price * days;
                                          }

                                          final _booking = ConfirmBooking(
                                            hotelRef: hotel.toRef(),
                                            userRef: appUser.toRef(),
                                            checkInDate: checkIn,
                                            checkOutDate: checkOut,
                                            rooms: _getListString(),
                                            issueDate: DateTime.now()
                                                .millisecondsSinceEpoch,
                                            total: _total,
                                            nights: days,
                                            ownerId: hotel.ownerId,
                                            isSeen: false,
                                            isContacted: false,
                                          );

                                          vm.confirmBooking(_booking, appUser);
                                        },
                                      ),
                                    ],
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

  List<Widget> _getString() {
    List<Widget> _list = [];
    for (final room in rooms) {
      _list.add(
        Text('${room.roomName}: ${room.adult} Adults, ${room.kid} Kids'),
      );
    }
    return _list;
  }

  List<String> _getListString() {
    List<String> _list = [];
    for (final room in rooms) {
      _list.add(
        '${room.roomName}: ${room.adult} Adults, ${room.kid} Kids',
      );
    }
    return _list;
  }

  Widget _appbarBuilder(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _topSectionBuilder(final AppUser appUser) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _userDetailBuilder(appUser),
        _issuedDateBuilder(),
      ],
    );
  }

  Widget _userDetailBuilder(final AppUser appUser) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$name',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22.0,
          ),
        ),
        Text(
          appUser.email,
        ),
        Text(
          '$phone',
        ),
      ],
    );
  }

  Widget _issuedDateBuilder() {
    final _date =
        DateHelper().getFormattedDate(DateTime.now().millisecondsSinceEpoch);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          'Issued Date :',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
        Text(_date),
      ],
    );
  }

  Widget _hotelDetailBuilder() {
    final _formattedCheckInDate = DateHelper().getFormattedDate(checkIn);
    final _formattedCheckOutDate = DateHelper().getFormattedDate(checkOut);
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
        if (rooms.isNotEmpty)
          SizedBox(
            height: 20.0,
          ),
        if (rooms.isNotEmpty)
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
        Text('$_formattedCheckInDate - $_formattedCheckOutDate'),
      ],
    );
  }

  Widget _totalPriceBuilder() {
    int _price = 0;
    if (rooms.isNotEmpty) {
      for (final room in rooms) {
        _price += room.price;
      }
    } else {
      _price = hotel.price;
    }
    final _total = _price * days;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Total',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22.0,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              'Rs $_total',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
            ),
            Text(
              'for $days night',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black26,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
