import 'package:flutter/material.dart';
import 'package:motel/viewmodels/add_new_tour_vm.dart';
import 'package:motel/views/widgets/hotels_tab_widgets/new_hotel_field.dart';

class AddTourDetails extends StatelessWidget {
  final AddNewTourVm vm;
  AddTourDetails(this.vm);

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
              _inputFieldContainer(vm),
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
      'Add tour details',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
      ),
    );
  }

  Widget _inputFieldContainer(AddNewTourVm vm) {
    return Column(
      children: [
        NewHotelField(
          hintText: 'Tour title',
          controller: vm.nameController,
        ),
        SizedBox(
          height: 30.0,
        ),
        Row(
          children: [
            Expanded(
              child: NewHotelField(
                hintText: 'Number of days',
                controller: vm.daysController,
                textInputType: TextInputType.number,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: NewHotelField(
                hintText: 'Number of nights',
                controller: vm.nightsController,
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
        Row(
          children: [
            Expanded(
              child: NewHotelField(
                hintText: 'Start',
                controller: vm.startController,
                textInputType: TextInputType.number,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: NewHotelField(
                hintText: 'End',
                controller: vm.endController,
                textInputType: TextInputType.number,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30.0,
        ),
        NewHotelField(
          hintText: 'Number of person',
          textInputType: TextInputType.number,
          controller: vm.personController,
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
        SizedBox(
          height: 30.0,
        ),
        NewHotelField(
          hintText: 'Inclusions Policy',
          isExpanded: true,
          controller: vm.inclusionsController,
          requiredCapitalization: false,
        ),
        SizedBox(
          height: 30.0,
        ),
        NewHotelField(
          hintText: 'Exclusions Policy',
          isExpanded: true,
          controller: vm.exclusionsController,
          requiredCapitalization: false,
        ),
      ],
    );
  }
}
