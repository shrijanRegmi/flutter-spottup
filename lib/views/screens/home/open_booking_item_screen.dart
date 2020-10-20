import 'package:flutter/material.dart';
import 'package:motel/enums/booking_type.dart';
import 'package:motel/helpers/date_helper.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/viewmodels/booking_tab_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';

class OpenBookingItemScreen extends StatelessWidget {
  final ConfirmHotelBooking booking;
  final AppUser appUser;
  final Hotel hotel;
  final BookingType bookingType;
  final bool admin;
  OpenBookingItemScreen(
    this.booking,
    this.appUser,
    this.hotel, {
    this.bookingType,
    this.admin = false,
  });

  @override
  Widget build(BuildContext context) {
    return VmProvider<BookingTabVm>(
      vm: BookingTabVm(context),
      onInit: (vm) {
        final _newVal = booking.isAccepted && !booking.isDeclined
            ? 'Accepted'
            : booking.isDeclined && !booking.isAccepted ? 'Declined' : '';
        vm.updateAcceptDeclineText(_newVal);
      },
      builder: (context, vm, appUser) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height - kToolbarHeight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _appbarBuilder(context, vm),
                    SizedBox(
                      height: 10.0,
                    ),
                    if (vm.acceptDeclineText == '' && !admin)
                      _acceptDeclineBuilder(vm),
                    if (vm.acceptDeclineText == '' && !admin)
                      SizedBox(height: 20.0),
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
                                  ],
                                ),
                              ),
                            ),
                            _totalPriceBuilder(),
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
    for (final room in booking.rooms) {
      _list.add(
        Text('$room'),
      );
    }
    return _list;
  }

  Widget _appbarBuilder(BuildContext context, BookingTabVm vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        Row(
          children: [
            Text(
              '${vm.acceptDeclineText}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: vm.acceptDeclineText == 'Declined'
                    ? Colors.red
                    : Color(0xff45ad90),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
          ],
        )
      ],
    );
  }

  Widget _acceptDeclineBuilder(BookingTabVm vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: MaterialButton(
                child: Text('Accept'),
                color: Color(0xff45ad90),
                minWidth: 180.0,
                textColor: Colors.white,
                onPressed: () => vm.acceptBooking(booking.bookingId),
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
                onPressed: () => vm.declineBooking(booking.bookingId),
              ),
            ),
          ),
        ],
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
          '${appUser.firstName} ${appUser.lastName}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22.0,
          ),
        ),
        Text(
          appUser.email,
        ),
        Text(
          '${appUser.phone}',
        ),
      ],
    );
  }

  Widget _issuedDateBuilder() {
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
            '${DateHelper().getFormattedDate(booking.checkInDate)} - ${DateHelper().getFormattedDate(booking.checkOutDate)}'),
      ],
    );
  }

  Widget _totalPriceBuilder() {
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
              'Rs ${booking.total}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.0,
              ),
            ),
            Text(
              'for ${booking.nights} night',
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
