import 'package:flutter/material.dart';
import 'package:motel/viewmodels/add_new_vehicle_vm.dart';
import 'package:motel/views/widgets/hotels_tab_widgets/new_hotel_field.dart';

class AddVehicleDetails extends StatefulWidget {
  final AddNewVehicleVm vm;
  AddVehicleDetails(this.vm);

  @override
  _AddVehicleDetailsState createState() => _AddVehicleDetailsState();
}

class _AddVehicleDetailsState extends State<AddVehicleDetails> {
  var _rad1 = -1;
  var _rad2 = -1;
  var _rad3 = -1;
  var _rad4 = -1;
  var _rad5 = -1;
  var _rad6 = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _hotelDetailTextBuilder(),
              SizedBox(
                height: 20.0,
              ),
              _inputFieldContainer(widget.vm),
              SizedBox(
                height: 40.0,
              ),
              _whoWillPayBuilder(),
            ],
          ),
        ),
        SizedBox(
          height: 40.0,
        ),
      ],
    );
  }

  Widget _hotelDetailTextBuilder() {
    return Text(
      'Add vehicle details',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
      ),
    );
  }

  Widget _inputFieldContainer(AddNewVehicleVm vm) {
    return Column(
      children: [
        NewHotelField(
          hintText: 'Car/Bus service title',
          controller: vm.nameController,
        ),
        SizedBox(
          height: 30.0,
        ),
        Row(
          children: [
            Expanded(
              child: NewHotelField(
                hintText: 'Model Year',
                controller: vm.modelYearController,
                textInputType: TextInputType.number,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: NewHotelField(
                hintText: 'Number of seats',
                controller: vm.seatsController,
                textInputType: TextInputType.number,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30.0,
        ),
        NewHotelField(
          hintText: 'Price',
          textInputType: TextInputType.number,
          controller: vm.priceController,
        ),
        SizedBox(
          height: 30.0,
        ),
        NewHotelField(
          hintText: 'Summary',
          isExpanded: true,
          controller: vm.summaryController,
          requiredCapitalization: false,
        ),
      ],
    );
  }

  Widget _whoWillPayBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Click the relevant box',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14.0,
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        ///////////////
        Text(
          '1. Rent Per Day is',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        RadioListTile(
          groupValue: _rad1,
          value: 0,
          onChanged: (val) {
            setState(() {
              _rad1 = val;
            });

            final _result = {
              'title': 'Rent Per Day is',
              'value': 'With Driver',
            };

            widget.vm.updateResult1(_result);
          },
          title: Text('With Driver'),
        ),
        RadioListTile(
          groupValue: _rad1,
          value: 1,
          onChanged: (val) {
            setState(() {
              _rad1 = val;
            });

            final _result = {
              'title': 'Rent Per Day is',
              'value': 'Without Driver',
            };

            widget.vm.updateResult1(_result);
          },
          title: Text('Without Driver'),
        ),
        Text(
          '2. Who Will Pay for Toll Tax',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        RadioListTile(
          groupValue: _rad2,
          value: 2,
          onChanged: (val) {
            setState(() {
              _rad2 = val;
            });

            final _result = {
              'title': 'Who Will Pay for Toll Tax',
              'value': 'Company',
            };

            widget.vm.updateResult2(_result);
          },
          title: Text('Company'),
        ),
        RadioListTile(
          groupValue: _rad2,
          value: 3,
          onChanged: (val) {
            setState(() {
              _rad2 = val;
            });
            final _result = {
              'title': 'Who Will Pay for Toll Tax',
              'value': 'Client',
            };

            widget.vm.updateResult2(_result);
          },
          title: Text('Client'),
        ),
        Text(
          '3. Who will pay for Daily Fuel',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        RadioListTile(
          groupValue: _rad3,
          value: 4,
          onChanged: (val) {
            setState(() {
              _rad3 = val;
            });
            final _result = {
              'title': 'Who will pay for Daily Fuel',
              'value': 'Company',
            };

            widget.vm.updateResult3(_result);
          },
          title: Text('Company'),
        ),
        RadioListTile(
          groupValue: _rad3,
          value: 5,
          onChanged: (val) {
            setState(() {
              _rad3 = val;
            });
            final _result = {
              'title': 'Who will pay for Daily Fuel',
              'value': 'Client',
            };

            widget.vm.updateResult3(_result);
          },
          title: Text('Client'),
        ),
        Text(
          '4. Who will pay for Driver Meal',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        RadioListTile(
          groupValue: _rad4,
          value: 6,
          onChanged: (val) {
            setState(() {
              _rad4 = val;
            });
            final _result = {
              'title': 'Who will pay for Driver Meal',
              'value': 'Company',
            };

            widget.vm.updateResult4(_result);
          },
          title: Text('Company'),
        ),
        RadioListTile(
          groupValue: _rad4,
          value: 7,
          onChanged: (val) {
            setState(() {
              _rad4 = val;
            });
            final _result = {
              'title': 'Who will pay for Driver Meal',
              'value': 'Client',
            };

            widget.vm.updateResult4(_result);
          },
          title: Text('Client'),
        ),
        Text(
          '5. Who will pay for Driver Accommodation',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        RadioListTile(
          groupValue: _rad5,
          value: 8,
          onChanged: (val) {
            setState(() {
              _rad5 = val;
            });
            final _result = {
              'title': 'Who will pay for Driver Accommodation',
              'value': 'Company',
            };

            widget.vm.updateResult5(_result);
          },
          title: Text('Company'),
        ),
        RadioListTile(
          groupValue: _rad5,
          value: 9,
          onChanged: (val) {
            setState(() {
              _rad5 = val;
            });
            final _result = {
              'title': 'Who will pay for Driver Accommodation',
              'value': 'Client',
            };

            widget.vm.updateResult5(_result);
          },
          title: Text('Client'),
        ),
        Text(
          '6. Who will pay for Traffic Fines',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        RadioListTile(
          groupValue: _rad6,
          value: 10,
          onChanged: (val) {
            setState(() {
              _rad6 = val;
            });
            final _result = {
              'title': 'Who will pay for Traffic Fines',
              'value': 'Company',
            };

            widget.vm.updateResult6(_result);
          },
          title: Text('Company'),
        ),
        RadioListTile(
          groupValue: _rad6,
          value: 11,
          onChanged: (val) {
            setState(() {
              _rad6 = val;
            });
            final _result = {
              'title': 'Who will pay for Traffic Fines',
              'value': 'Client',
            };

            widget.vm.updateResult6(_result);
          },
          title: Text('Client'),
        ),
      ],
    );
  }
}
