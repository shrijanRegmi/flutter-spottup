import 'package:flutter/material.dart';
import 'package:motel/helpers/date_helper.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';

class ProceedBookingScreen extends StatelessWidget {
  final Hotel hotel;
  final int days;
  final int checkIn;
  final int checkOut;
  ProceedBookingScreen({this.hotel, this.days, this.checkIn, this.checkOut});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - kToolbarHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 20.0,
                      ),
                      _topSectionBuilder(),
                      SizedBox(
                        height: 20.0,
                      ),
                      _hotelDetailBuilder(),
                      SizedBox(
                        height: 40.0,
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      _totalPriceBuilder(),
                      SizedBox(
                        height: 20.0,
                      ),
                      RoundedBtn(
                        title: 'Confirm Booking',
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
          'Shrijan Regmi',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22.0,
          ),
        ),
        Text(
          'ilyyhs9@gmail.com',
        ),
        Text(
          '98387387888',
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
        Text(hotel.name),
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
    final _price = hotel.price;
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
              '\$$_total',
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
