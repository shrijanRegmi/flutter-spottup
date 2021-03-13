import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:motel/models/firebase/vehicle_model.dart';
import 'package:motel/viewmodels/vehicle_book_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/screens/home/proceed_vehicle_booking.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';
import 'package:motel/views/widgets/hotels_tab_widgets/new_hotel_field.dart';

class VehicleBookScreen extends StatefulWidget {
  @override
  _VehicleBookScreenState createState() => _VehicleBookScreenState();
  final Vehicle hotel;
  VehicleBookScreen(this.hotel);
}

class _VehicleBookScreenState extends State<VehicleBookScreen> {
  @override
  Widget build(BuildContext context) {
    return VmProvider<VehicleBookVm>(
      vm: VehicleBookVm(context),
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
                    _topSectionBuilder(context),
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
                    _numberBuilder(vm),
                    if (vm.isPersonConfirmed) _confirmationBuilder(vm),
                    if (vm.isPersonConfirmed && vm.isDetailsConfirmed)
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
                      height: 40.0,
                    ),
                    if (vm.isPersonConfirmed && vm.isDetailsConfirmed)
                      RoundedBtn(
                        title: 'Proceed',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProceedVehicleBookingScreen(
                                vehicle: widget.hotel,
                                name: vm.emailController.text.trim(),
                                phone: vm.phoneController.text.trim(),
                                males: int.parse(vm.maleController.text.trim()),
                                females:
                                    int.parse(vm.femaleController.text.trim()),
                                kids: int.parse(vm.kidController.text.trim()),
                                days: int.parse(vm.daysController.text.trim()),
                              ),
                            ),
                          );
                        },
                      ),
                    if (vm.isPersonConfirmed && vm.isDetailsConfirmed)
                      SizedBox(
                        height: 20.0,
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

  Widget _topSectionBuilder(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 200.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                widget.hotel.dp,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        _btnSection(context),
      ],
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

  Widget _numberBuilder(VehicleBookVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '1. Fill up details',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
              Text(
                'Fill up number of males, females, kids and days.',
              ),
              SizedBox(
                height: 10.0,
              ),
              NewHotelField(
                hintText: 'Number of males',
                textInputType: TextInputType.number,
                controller: vm.maleController,
                onChanged: (val) {
                  setState(() {});
                  vm.updateIsPersonConfirmed(false);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              NewHotelField(
                hintText: 'Number of females',
                textInputType: TextInputType.number,
                controller: vm.femaleController,
                onChanged: (val) {
                  setState(() {});
                  vm.updateIsPersonConfirmed(false);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              NewHotelField(
                hintText: 'Number of kids',
                textInputType: TextInputType.number,
                controller: vm.kidController,
                onChanged: (val) {
                  setState(() {});
                  vm.updateIsPersonConfirmed(false);
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              NewHotelField(
                hintText: 'Number of days',
                textInputType: TextInputType.number,
                controller: vm.daysController,
                onChanged: (val) {
                  setState(() {});
                  vm.updateIsPersonConfirmed(false);
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Align(
          alignment: Alignment.center,
          child: MaterialButton(
            child: vm.isPersonConfirmed
                ? Icon(
                    Icons.check,
                    color: Colors.white,
                  )
                : Text('Next'),
            color: Color(0xff45ad90),
            textColor: Colors.white,
            disabledColor: Colors.grey.withOpacity(0.3),
            minWidth: 180.0,
            onPressed: vm.maleController.text.trim() != '' &&
                    vm.femaleController.text.trim() != '' &&
                    vm.kidController.text.trim() != '' &&
                    vm.daysController.text.trim() != ''
                ? () => vm.updateIsPersonConfirmed(true)
                : null,
          ),
        ),
        SizedBox(height: 40.0)
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
          SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Model Year: ${widget.hotel.modelYear}',
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
                            Text(
                              '${widget.hotel.seats} Seats',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.black26,
                              ),
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
                    'Rs ${widget.hotel}',
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
        ],
      ),
    );
  }

  Widget _grandTotalPriceBuilder(VehicleBookVm vm) {
    int _price = widget.hotel.price;
    final _totalPrice = _price;

    final _days = int.parse(vm.daysController.text.trim());

    final _grandTotalPrice = _totalPrice * _days;

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
                'Rs $_totalPrice x $_days',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
              Text(
                '= Rs $_grandTotalPrice',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
              Text(
                'for $_days days',
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

  Widget _confirmationBuilder(VehicleBookVm vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '3. Confirmation',
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
              vm.updateIsDetailsConfirmed(false);
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
              vm.updateIsDetailsConfirmed(false);
            },
          ),
          SizedBox(
            height: 30.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              MaterialButton(
                child: vm.isDetailsConfirmed
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
