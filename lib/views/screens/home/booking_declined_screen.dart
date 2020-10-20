import 'package:flutter/material.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';

class BookingDeclinedScreen extends StatelessWidget {
  final ConfirmHotelBooking booking;
  final Hotel hotel;
  BookingDeclinedScreen(this.booking, this.hotel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _appbarBuilder(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _bookingDeclineTextBuilder(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _detailsBuilder(),
                  ],
                ),
              ),
              SizedBox(
                height: 50.0,
              ),
              RoundedBtn(
                title: 'OK, Got it',
                onPressed: () => Navigator.pop(context),
              ),
            ],
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

  Widget _bookingDeclineTextBuilder() {
    return Text(
      '${hotel.name} - The booking was declined !',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 22.0,
      ),
    );
  }

  Widget _detailsBuilder() {
    return Text(
      'Sorry, we decided to decline the booking for the reason; ${booking.declineText.toLowerCase()}',
    );
  }
}
