import 'package:flutter/material.dart';
import 'package:motel/helpers/date_helper.dart';
import 'package:motel/viewmodels/add_new_hotel_vm.dart';
import 'package:motel/views/widgets/hotels_tab_widgets/new_hotel_field.dart';

class AddHotelDetail extends StatefulWidget {
  final AddNewHotelVm vm;
  final bool isRoom;
  AddHotelDetail(this.vm, {this.isRoom = false});

  @override
  _AddHotelDetailState createState() => _AddHotelDetailState();
}

class _AddHotelDetailState extends State<AddHotelDetail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
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
                ],
              ),
            ),
            _inputFieldContainer(widget.vm, context),
          ],
        ),
        SizedBox(
          height: 40.0,
        ),
      ],
    );
  }

  Widget _hotelDetailTextBuilder() {
    return Text(
      widget.isRoom ? 'Add room details' : 'Add hotel details',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
      ),
    );
  }

  Widget _inputFieldContainer(AddNewHotelVm vm, final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            children: [
              NewHotelField(
                hintText: widget.isRoom ? 'Room title' : 'Hotel title',
                controller:
                    widget.isRoom ? vm.roomNameController : vm.nameController,
              ),
              SizedBox(
                height: 30.0,
              ),
              Row(
                children: [
                  Expanded(
                    child: NewHotelField(
                      hintText: widget.isRoom ? 'Adults' : 'City',
                      controller: widget.isRoom
                          ? vm.roomAdultController
                          : vm.cityController,
                      textInputType: widget.isRoom
                          ? TextInputType.number
                          : TextInputType.text,
                    ),
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Expanded(
                    child: NewHotelField(
                      hintText: widget.isRoom ? 'Kids' : 'Country',
                      controller: widget.isRoom
                          ? vm.roomKidController
                          : vm.countryController,
                      textInputType: widget.isRoom
                          ? TextInputType.number
                          : TextInputType.text,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              NewHotelField(
                hintText: 'Summary',
                isExpanded: true,
                controller: widget.isRoom
                    ? vm.roomSummaryController
                    : vm.summaryController,
                requiredCapitalization: false,
              ),
              SizedBox(
                height: 30.0,
              ),
              if (widget.isRoom)
                NewHotelField(
                  hintText: 'Default Price',
                  textInputType: TextInputType.number,
                  controller: widget.isRoom
                      ? vm.roomPriceController
                      : vm.priceController,
                ),
              if (widget.isRoom)
                SizedBox(
                  height: 10.0,
                ),
            ],
          ),
        ),
        if (widget.isRoom) _priceBasedonDateBuilder(context),
      ],
    );
  }

  _priceBasedonDateBuilder(final BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            'You can also set price of the rooms based on the date you specify. Press the button below to set price based on dates.',
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        ..._roomPricesBuilder(),
        if (widget.vm.roomPrices.isNotEmpty)
          SizedBox(
            height: 10.0,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: MaterialButton(
            child: Text('Add Price'),
            color: Color(0xff45ad90),
            minWidth: 180.0,
            textColor: Colors.white,
            onPressed: () async {
              await widget.vm.showAddRoomPriceDialog(context);
              setState(() {});
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _roomPricesBuilder() {
    final _list = <Widget>[];
    widget.vm.roomPrices.forEach((element) {
      _list.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Container(
            color: Colors.grey[200],
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'From: ${DateHelper().getFormattedDate(element.fromDate)}',
                          ),
                          Text(
                            'To: ${DateHelper().getFormattedDate(element.toDate)}',
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Price: Rs ${element.price}',
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                InkWell(
                  onTap: () {
                    final _newRoomPrices = widget.vm.roomPrices;
                    _newRoomPrices.remove(element);
                    widget.vm.updateRoomPrices(_newRoomPrices);
                    setState(() {});
                  },
                  child: Icon(Icons.close),
                ),
              ],
            ),
          ),
        ),
      );
    });
    return _list;
  }
}
