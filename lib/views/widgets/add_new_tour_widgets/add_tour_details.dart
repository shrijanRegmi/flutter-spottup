import 'package:flutter/material.dart';
import 'package:motel/helpers/date_helper.dart';
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
              _inputFieldContainer(vm, context),
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

  Widget _inputFieldContainer(AddNewTourVm vm, BuildContext context) {
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
          children: <Widget>[
            Expanded(
              child: Text(
                'Tour start date: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            vm.start == null
                ? MaterialButton(
                    child: Text('Select start date'),
                    color: Color(0xff45ad90),
                    minWidth: 180.0,
                    textColor: Colors.white,
                    onPressed: vm.showStartTourDialog,
                  )
                : GestureDetector(
                    onTap: vm.showStartTourDialog,
                    child: Text(
                      DateHelper()
                          .getFormattedDate(vm.start.millisecondsSinceEpoch),
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
          children: <Widget>[
            Expanded(
              child: Text(
                'Tour end date: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            vm.end == null
                ? MaterialButton(
                    child: Text('Select end date'),
                    color: Color(0xff45ad90),
                    minWidth: 180.0,
                    textColor: Colors.white,
                    onPressed: vm.showEndTourDialog,
                  )
                : GestureDetector(
                    onTap: vm.showEndTourDialog,
                    child: Text(
                      DateHelper()
                          .getFormattedDate(vm.end.millisecondsSinceEpoch),
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
          children: <Widget>[
            Expanded(
              child: Text(
                'Pick up date: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            vm.pickUpDate == null
                ? MaterialButton(
                    child: Text('Select pick up date'),
                    color: Color(0xff45ad90),
                    minWidth: 180.0,
                    textColor: Colors.white,
                    onPressed: vm.showPickUpDateDialog,
                  )
                : GestureDetector(
                    onTap: vm.showPickUpDateDialog,
                    child: Text(
                      DateHelper().getFormattedDate(
                          vm.pickUpDate.millisecondsSinceEpoch),
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
          children: <Widget>[
            Expanded(
              child: Text(
                'Pick up time: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 10.0,
            ),
            vm.pickUpTime == null
                ? MaterialButton(
                    child: Text('Select pick up time'),
                    color: Color(0xff45ad90),
                    minWidth: 180.0,
                    textColor: Colors.white,
                    onPressed: vm.showPickUpTimeDialog,
                  )
                : GestureDetector(
                    onTap: vm.showPickUpTimeDialog,
                    child: Text(
                      '${vm.pickUpTime.format(context)}',
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
          hintText: 'Number of person',
          textInputType: TextInputType.number,
          controller: vm.personController,
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
        SizedBox(
          height: 30.0,
        ),
        NewHotelField(
          hintText: 'Payment and Cancellation Policy',
          isExpanded: true,
          controller: vm.paymentPolicyController,
          requiredCapitalization: false,
        ),
      ],
    );
  }
}
