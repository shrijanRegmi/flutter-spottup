import 'package:flutter/material.dart';
import 'package:motel/viewmodels/add_new_hotel_vm.dart';
import 'package:motel/views/widgets/hotels_tab_widgets/new_hotel_field.dart';

class AddHotelDetail extends StatelessWidget {
  final AddNewHotelVm vm;
  final bool isRoom;
  AddHotelDetail(this.vm, {this.isRoom = false});

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
      isRoom ? 'Add room details' : 'Add hotel details',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
      ),
    );
  }

  Widget _inputFieldContainer(AddNewHotelVm vm) {
    return Column(
      children: [
        NewHotelField(
          hintText: isRoom ? 'Room title' : 'Hotel title',
          controller: isRoom ? vm.roomNameController : vm.nameController,
        ),
        SizedBox(
          height: 30.0,
        ),
        Row(
          children: [
            Expanded(
              child: NewHotelField(
                hintText: isRoom ? 'Adults' : 'City',
                controller: isRoom ? vm.roomAdultController : vm.cityController,
                textInputType:
                    isRoom ? TextInputType.number : TextInputType.text,
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: NewHotelField(
                hintText: isRoom ? 'Kids' : 'Country',
                controller:
                    isRoom ? vm.roomKidController : vm.countryController,
                textInputType:
                    isRoom ? TextInputType.number : TextInputType.text,
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
          controller: isRoom ? vm.roomPriceController : vm.priceController,
        ),
        SizedBox(
          height: 30.0,
        ),
        NewHotelField(
          hintText: 'Summary',
          isExpanded: true,
          controller: isRoom ? vm.roomSummaryController : vm.summaryController,
          requiredCapitalization: false,
        ),
      ],
    );
  }
}
