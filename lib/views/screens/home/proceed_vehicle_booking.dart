import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:motel/helpers/date_helper.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/models/firebase/vehicle_model.dart';
import 'package:motel/viewmodels/vehicle_book_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';

class ProceedVehicleBookingScreen extends StatelessWidget {
  final Vehicle vehicle;
  final String name;
  final String phone;
  final int males;
  final int females;
  final int kids;
  final int days;
  ProceedVehicleBookingScreen({
    this.vehicle,
    this.name,
    this.phone,
    this.males,
    this.females,
    this.kids,
    this.days,
  });

  @override
  Widget build(BuildContext context) {
    return VmProvider<VehicleBookVm>(
      vm: VehicleBookVm(context),
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

                                          _total = vehicle.price *
                                              (males + females + kids);

                                          final _booking = ConfirmVehicleBooking(
                                            vehicleRef: vehicle.toRef(),
                                            userRef: appUser.toRef(),
                                            issueDate: DateTime.now()
                                                .millisecondsSinceEpoch,
                                            total: _total,
                                            ownerId: vehicle.ownerId,
                                            males: males,
                                            females: females,
                                            kids: kids,
                                            days: days,
                                            isAccepted: false,
                                            isDeclined: false,
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
          '$males',
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
          '$females',
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
          '$kids',
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
    final _total = vehicle.price * days;

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
              'for $days days',
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
