import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:motel/helpers/date_helper.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/viewmodels/booking_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/screens/home/proceed_booking_screen.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';

class BookScreen extends StatefulWidget {
  @override
  _BookScreenState createState() => _BookScreenState();
  final Hotel hotel;
  BookScreen(this.hotel);
}

class _BookScreenState extends State<BookScreen> {
  @override
  Widget build(BuildContext context) {
    return VmProvider<BookVm>(
      vm: BookVm(context: context),
      builder: (context, vm, appUser) {
        return Scaffold(
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Container(
              color: Colors.transparent,
              child: SingleChildScrollView(
                controller: vm.scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _topSection(context),
                    SizedBox(
                      height: 20.0,
                    ),
                    _hotelDetailBuilder(),
                    SizedBox(
                      height: 10.0,
                    ),
                    Divider(),
                    SizedBox(
                      height: 10.0,
                    ),
                    _bookNowTextBuilder(),
                    SizedBox(
                      height: 30.0,
                    ),
                    _checkAvailabilityBuilder(vm),
                    SizedBox(
                      height: 40.0,
                    ),
                    _confirmationBuilder(vm),
                    if (vm.isEmailPhoneConfirmed && vm.isBookingAvailable)
                      Column(
                        children: <Widget>[
                          SizedBox(
                            height: 40.0,
                          ),
                          Divider(),
                          SizedBox(
                            height: 10.0,
                          ),
                          _grandTotalPriceBuilder(vm),
                          SizedBox(
                            height: 10.0,
                          ),
                          Divider(),
                        ],
                      ),
                    SizedBox(
                      height: vm.isEmailPhoneConfirmed && vm.isBookingAvailable
                          ? 10.0
                          : 40.0,
                    ),
                    if (vm.isEmailPhoneConfirmed && vm.isBookingAvailable)
                      RoundedBtn(
                        title: 'Proceed',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProceedBookingScreen(
                                hotel: widget.hotel,
                                days: vm.checkOutDate
                                    .difference(vm.checkInDate)
                                    .inDays,
                                checkIn: vm.checkInDate.millisecondsSinceEpoch,
                                checkOut:
                                    vm.checkOutDate.millisecondsSinceEpoch,
                                name: vm.emailController.text.trim(),
                                phone: vm.phoneController.text.trim(),
                              ),
                            ),
                          );
                        },
                      ),
                    if (vm.isEmailPhoneConfirmed && vm.isBookingAvailable)
                      SizedBox(
                        height: 40.0,
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

  Widget _bookNowTextBuilder() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Text(
        'Book now',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22.0,
        ),
      ),
    );
  }

  Widget _topSection(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 200.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(widget.hotel.dp),
              fit: BoxFit.cover,
            ),
          ),
        ),
        _btnSection(context),
      ],
    );
  }

  Widget _btnSection(BuildContext context) {
    final _size = 50.0;
    return Column(
      children: <Widget>[
        SizedBox(
          height: 40.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: _size,
                height: _size,
                child: FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  backgroundColor: Colors.black87,
                  heroTag: 'backBtn2',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _hotelDetailBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.hotel.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22.0,
                  ),
                ),
                Text(
                  '${widget.hotel.city}, ${widget.hotel.country}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black26,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: Color(0xff45ad90),
                              size: 18.0,
                            ),
                            Text(
                              '4 Km from city',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black26,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '\$${widget.hotel.price}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22.0,
                ),
              ),
              Text(
                '/per night',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black26,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _grandTotalPriceBuilder(BookVm vm) {
    final _price = widget.hotel.price;
    final _commission = widget.hotel.commission;
    final _commissionPrice = _commission / 100 * _price;
    final _totalPrice = _price + _commissionPrice;

    int _days;
    if (vm.checkInDate != null && vm.checkOutDate != null) {
      _days = vm.checkOutDate.difference(vm.checkInDate).inDays;
    }

    final _grandTotalPrice = _days == null ? 0 : _totalPrice * _days;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Grand Total',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22.0,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '\$$_totalPrice x $_days',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
              Text(
                '= \$$_grandTotalPrice',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
              Text(
                _days == 1 ? 'for $_days night' : 'for $_days nights',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black26,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _checkAvailabilityBuilder(BookVm vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '1. Check Availability',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
          Text(
            'Select your check in and check out dates to know if the bookings are available or not.',
          ),
          SizedBox(
            height: 20.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Check in date: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              vm.checkInDate == null
                  ? MaterialButton(
                      child: Text('Select check in date'),
                      color: Color(0xff45ad90),
                      minWidth: 180.0,
                      textColor: Colors.white,
                      onPressed: vm.showCheckInDialog,
                    )
                  : GestureDetector(
                      onTap: vm.showCheckInDialog,
                      child: Text(
                        DateHelper().getFormattedDate(
                            vm.checkInDate.millisecondsSinceEpoch),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ],
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Check out date: ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 10.0,
              ),
              vm.checkOutDate == null
                  ? MaterialButton(
                      child: Text('Select check out date'),
                      color: Color(0xff45ad90),
                      textColor: Colors.white,
                      minWidth: 180.0,
                      onPressed: vm.showCheckOutDialog,
                    )
                  : GestureDetector(
                      onTap: vm.showCheckOutDialog,
                      child: Text(
                        DateHelper().getFormattedDate(
                            vm.checkOutDate.millisecondsSinceEpoch),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ],
          ),
          SizedBox(
            height: 30.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                child: vm.isBookingAvailable
                    ? Icon(
                        Icons.check,
                        color: Colors.white,
                      )
                    : Text('Check Availability'),
                color: Color(0xff45ad90),
                minWidth: 180.0,
                textColor: Colors.white,
                disabledColor: Colors.grey.withOpacity(0.3),
                onPressed: vm.checkInDate == null || vm.checkOutDate == null
                    ? null
                    : () => vm.checkAvailability(widget.hotel),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _confirmationBuilder(BookVm vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '2. Confirmation',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Confirm your name',
            ),
            textCapitalization: TextCapitalization.words,
            controller: vm.emailController,
            onChanged: (val) {
              setState(() {});
              vm.updateConfirmation();
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Confirm your phone',
            ),
            keyboardType: TextInputType.phone,
            controller: vm.phoneController,
            onChanged: (val) {
              setState(() {});
              vm.updateConfirmation();
            },
          ),
          SizedBox(
            height: 30.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                child: vm.isEmailPhoneConfirmed
                    ? Icon(
                        Icons.check,
                        color: Colors.white,
                      )
                    : Text('Confirm'),
                color: Color(0xff45ad90),
                minWidth: 180.0,
                textColor: Colors.white,
                disabledColor: Colors.grey.withOpacity(0.3),
                onPressed: vm.emailController.text == '' ||
                        vm.phoneController.text == ''
                    ? null
                    : vm.checkEmailPhone,
              ),
            ],
          )
        ],
      ),
    );
  }
}
