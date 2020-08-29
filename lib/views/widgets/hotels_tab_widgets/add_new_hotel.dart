import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/viewmodels/add_new_hotel_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';
import 'package:motel/views/widgets/hotels_tab_widgets/new_hotel_field.dart';

class AddNewHotel extends StatefulWidget {
  final Hotel hotel;
  AddNewHotel({this.hotel});

  @override
  _AddNewHotelState createState() => _AddNewHotelState();
}

class _AddNewHotelState extends State<AddNewHotel> {
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
    return VmProvider<AddNewHotelVm>(
      vm: AddNewHotelVm(),
      builder: (context, vm, appUser) {
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _isTyping
              ? Container()
              : RoundedBtn(
                  title: vm.isNextPressed ? 'Confirm' : 'Next',
                  onPressed: () {
                    vm.onNextPressed(true);
                  },
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
                      _appbarBuilder(context, vm),
                      vm.isNextPressed
                          ? _addImageBuilder(vm)
                          : _hotelDetailBuilder(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _hotelDetailBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _loginTextBuilder(),
              SizedBox(
                height: 30.0,
              ),
              _inputFieldContainer(),
            ],
          ),
        ),
        SizedBox(
          height: 40.0,
        ),
      ],
    );
  }

  Widget _appbarBuilder(BuildContext context, AddNewHotelVm vm) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        if (vm.isNextPressed) {
          vm.onNextPressed(false);
        } else {
          Navigator.pop(context);
        }
      },
    );
  }

  Widget _loginTextBuilder() {
    return Text(
      'Add new hotel',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 22.0,
      ),
    );
  }

  Widget _inputFieldContainer() {
    return Column(
      children: [
        NewHotelField(
          hintText: 'Hotel title',
        ),
        SizedBox(
          height: 30.0,
        ),
        Row(
          children: [
            Expanded(
              child: NewHotelField(
                hintText: 'City',
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Expanded(
              child: NewHotelField(
                hintText: 'Country',
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
        ),
        SizedBox(
          height: 30.0,
        ),
        NewHotelField(
          hintText: 'Summary',
          isExpanded: true,
        ),
      ],
    );
  }

  Widget _addImageBuilder(AddNewHotelVm vm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: _loginTextBuilder(),
        ),
        _addDpBuilder(context, vm),
        _addPhotoBuilder(vm),
        SizedBox(
          height: 60.0,
        ),
      ],
    );
  }

  Widget _addDpBuilder(BuildContext context, AddNewHotelVm vm) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: vm.uploadDp,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 200.0,
          decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Color(0xff45ad90),
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(5.0),
            image: vm.dp != null
                ? DecorationImage(
                    image: FileImage(vm.dp),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: vm.dp != null
              ? Container()
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        color: Color(0xff45ad90),
                        size: 30.0,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _addPhotoBuilder(AddNewHotelVm vm) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Wrap(
        children: [
          ..._imgListBuilder(vm),
          Padding(
            padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
            child: GestureDetector(
              onTap: vm.uploadPhotos,
              child: Container(
                width: 100.0,
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
                        Icons.add_photo_alternate,
                        color: Color(0xff45ad90),
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _imgListBuilder(AddNewHotelVm vm) {
    List<Widget> _list = [];
    vm.photos.forEach((element) {
      _list.add(
        Padding(
          padding: const EdgeInsets.only(right: 20.0, bottom: 20.0),
          child: GestureDetector(
            onTap: vm.uploadPhotos,
            child: Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  color: Color(0xff45ad90),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(5.0),
                image: DecorationImage(
                  image: FileImage(element),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      );
    });
    return _list;
  }
}
