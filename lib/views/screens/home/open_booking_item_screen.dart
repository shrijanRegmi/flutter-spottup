import 'package:flutter/material.dart';
import 'package:motel/enums/booking_type.dart';
import 'package:motel/helpers/date_helper.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/viewmodels/booking_tab_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';

class OpenBookingItemScreen extends StatelessWidget {
  final ConfirmBooking booking;
  final AppUser appUser;
  final Hotel hotel;
  final BookingType bookingType;
  OpenBookingItemScreen(
    this.booking,
    this.appUser,
    this.hotel, {
    this.bookingType,
  });

  @override
  Widget build(BuildContext context) {
    return VmProvider<BookingTabVm>(
      vm: BookingTabVm(context),
      onInit: (vm) {
        if (!booking.isSeen) {
          vm.updateSeenState(bookingType, booking.bookingId);
        }
        vm.updateIsContacted(booking.isContacted);
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
                      height: 20.0,
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
        IconButton(
          icon: Icon(
            vm.isContacted ? Icons.check_circle : Icons.check_circle_outline,
          ),
          onPressed: () => vm.onPressedContactedBtn(booking.bookingId),
        ),
      ],
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
