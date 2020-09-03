import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/viewmodels/add_new_hotel_vm.dart';
import 'package:motel/views/widgets/add_new_hotel_widgets/add_hotel_details.dart';
import 'package:motel/views/widgets/add_new_hotel_widgets/add_hotel_photos.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';
import 'package:provider/provider.dart';

class AddNewRoom extends StatefulWidget {
  final AddNewHotelVm vm;
  AddNewRoom(this.vm);

  @override
  _AddNewRoomState createState() => _AddNewRoomState();
}

class _AddNewRoomState extends State<AddNewRoom> {
  bool _isTyping = false;
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = KeyboardVisibility.onChange.listen((event) {
      setState(() {
        _isTyping = event;
      });
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _isTyping
          ? Container()
          : RoundedBtn(
              title: 'Confirm',
              onPressed: () => widget.vm.addRoomList(context, _appUser.uid),
            ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _appbarBuilder(context),
                  _addNewHotelBuilder(),
                  SizedBox(
                    height: 20.0,
                  ),
                  AddHotelDetail(widget.vm, isRoom: true),
                  AddHotelPhotos(widget.vm, isRoom: true),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _appbarBuilder(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _addNewHotelBuilder() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Text(
        'Add New Room',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22.0,
        ),
      ),
    );
  }
}
