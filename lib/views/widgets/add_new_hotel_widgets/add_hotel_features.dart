import 'package:flutter/material.dart';
import 'package:motel/models/app/hotel_features.dart';
import 'package:motel/viewmodels/add_new_hotel_vm.dart';

class AddHotelFeatures extends StatefulWidget {
  @override
  _AddHotelFeaturesState createState() => _AddHotelFeaturesState();
  final AddNewHotelVm vm;
  AddHotelFeatures(this.vm);
}

class _AddHotelFeaturesState extends State<AddHotelFeatures> {
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
              _hotelFeaturesTextBuilder(),
              SizedBox(
                height: 20.0,
              ),
              _festuresList(),
            ],
          ),
        ),
        SizedBox(
          height: 40.0,
        ),
      ],
    );
  }

  Widget _hotelFeaturesTextBuilder() {
    return Text(
      'Add hotel facilities',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
      ),
    );
  }

  Widget _festuresList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: featuresList.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          value: featuresList[index].isSelected,
          title: Text(featuresList[index].title),
          onChanged: (val) {
            setState(() {
              featuresList[index].isSelected = val;
            });
            val
                ? widget.vm.addFeature(featuresList[index])
                : widget.vm.removeFeature(featuresList[index]);
          },
        );
      },
    );
  }
}
