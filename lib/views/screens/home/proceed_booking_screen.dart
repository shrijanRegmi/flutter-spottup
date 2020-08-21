import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:lottie/lottie.dart';
import 'package:motel/helpers/date_helper.dart';
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
                                          final _checkInDate = DateHelper()
                                              .getFormattedDate(checkIn);
                                          final _checkOutDate = DateHelper()
                                              .getFormattedDate(checkOut);
                                          final _date = DateHelper()
                                              .getFormattedDate(DateTime.now()
                                                  .millisecondsSinceEpoch);
                                          final _total = hotel.price * days;

                                          final Email _email = Email(
                                            body:
                                                '<h1>$name</h1><p>${appUser.email}</p><p>$phone</p><div style="height: 30px;" ></div><h3 style="margin: 0px">Hotel Name:</h3><p>${hotel.name} : ${hotel.name}, ${hotel.city}, ${hotel.country}</p><div style="height: 30px;" ></div><h3 style="margin: 0px">Rooms :</h3>${_getHtmlString()}<div style="height: 30px;" ></div><h3 style="margin: 0px">Hotel Id:</h3><p>${hotel.id}</p><div style="height: 30px;" ></div><h3 style="margin: 0px">Check In - Check Out</h3><p>$_checkInDate - $_checkOutDate</p><div style="height: 30px;" ></div><h3 style="margin: 0px">Issue Date:</h3><p>$_date</p><div style="height: 20px;" ></div><div style="display: flex; align-items: flex-end;" ><h3>Total: </h3><div style="margin-left: 20px;"><h2 style="margin: 0px;" >Rs $_total</h2><p style="margin: 0px;">for $days night</p></div></div>',
                                            subject: '${hotel.name}',
                                            recipients: [
                                              'shrijanregmi9@gmail.com'
                                            ],
                                            isHTML: true,
                                          );

                                          vm.sendEmail(_email);
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

  String _getHtmlString() {
    String _string = '';
    for (final room in rooms) {
      _string +=
          '<p>${room.roomName}: ${room.adult} Adults, ${room.kid} Kids</p>';
    }
    print(_string);
    return _string;
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
