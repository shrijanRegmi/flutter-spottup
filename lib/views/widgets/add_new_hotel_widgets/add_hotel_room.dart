import 'dart:io';

import 'package:flutter/material.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/viewmodels/add_new_hotel_vm.dart';
import 'package:motel/views/widgets/hotels_tab_widgets/add_new_room.dart';

class AddHotelRoom extends StatelessWidget {
  final AddNewHotelVm vm;
  AddHotelRoom(this.vm);

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
              _addRoomTextBuilder(),
              SizedBox(
                height: 20.0,
              ),
              _roomListBuilder(),
            ],
          ),
        ),
        SizedBox(
          height: 60.0,
        ),
      ],
    );
  }

  Widget _addRoomTextBuilder() {
    return Text(
      'Add rooms',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
      ),
    );
  }

  Widget _roomListBuilder() {
    final _list = [Hotel(), ...vm.rooms.reversed];
    return Container(
      height: 150.0,
      child: ListView.builder(
        itemCount: _list.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
              child: GestureDetector(
                onTap: () {
                  vm.clearControllers();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AddNewRoom(vm),
                    ),
                  );
                },
                child: Container(
                  width: 150.0,
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Color(0xff45ad90),
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.hotel,
                          color: Color(0xff45ad90),
                          size: 20.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
          return _imgListItemBuilder(_list[index], File(_list[index].dp));
        },
      ),
    );
  }

  Widget _imgListItemBuilder(final Hotel room, final _img) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
      child: Container(
        width: 150.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: Color(0xff45ad90),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(5.0),
          image: DecorationImage(
            image: FileImage(_img),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: 40.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: IconButton(
                  icon: Icon(Icons.delete),
                  iconSize: 18.0,
                  color: Colors.grey[100],
                  onPressed: () => vm.removeRoom(room)),
            ),
          ),
        ),
      ),
    );
  }
}
