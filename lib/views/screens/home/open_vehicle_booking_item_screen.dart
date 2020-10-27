import 'package:flutter/material.dart';
import 'package:motel/enums/booking_type.dart';
import 'package:motel/helpers/date_helper.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/models/firebase/vehicle_model.dart';
import 'package:motel/viewmodels/booking_tab_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';

class OpenVehicleBookingItemScreen extends StatelessWidget {
  final ConfirmVehicleBooking booking;
  final AppUser appUser;
  final Vehicle vehicle;
  final BookingType bookingType;
  final bool admin;
  OpenVehicleBookingItemScreen(
    this.booking,
    this.appUser,
    this.vehicle, {
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
          'Car/Bus Service Name: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
        Text(
          vehicle.name,
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
          'Service Id: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.0,
          ),
        ),
        Text(vehicle.id),
        SizedBox(
          height: 20.0,
        ),
      ],
    );
  }

  Widget _totalPriceBuilder() {
    final _total = vehicle.price * booking.days;

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
              'for ${booking.days} days',
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
