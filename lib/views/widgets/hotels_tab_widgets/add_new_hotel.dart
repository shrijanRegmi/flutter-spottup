import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:lottie/lottie.dart';
import 'package:motel/models/app/hotel_features.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/viewmodels/add_new_hotel_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/widgets/add_new_hotel_widgets/add_hotel_details.dart';
import 'package:motel/views/widgets/add_new_hotel_widgets/add_hotel_features.dart';
import 'package:motel/views/widgets/add_new_hotel_widgets/add_hotel_photos.dart';
import 'package:motel/views/widgets/add_new_hotel_widgets/add_hotel_room.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';

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
      onInit: (vm) {
        featuresList.forEach((feature) {
          feature.isSelected = false;
        });
      },
      vm: AddNewHotelVm(),
      builder: (context, vm, appUser) {
        return Scaffold(
          key: vm.hotelScaffoldKey,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _isTyping || vm.isLoading
              ? Container()
              : RoundedBtn(
                  title: 'Publish Hotel',
                  onPressed: () {
                    vm.uploadNewHotel(context, appUser.uid);
                  },
                ),
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: vm.isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/lottie/loading.json'),
                          Text(
                            'Please wait. This may take some while.',
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            'Uploading Hotel Photos',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container(
                      color: Colors.transparent,
                      height: MediaQuery.of(context).size.height,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _appbarBuilder(context, vm),
                            _addNewHotelBuilder(),
                            SizedBox(
                              height: 20.0,
                            ),
                            AddHotelDetail(vm),
                            AddHotelFeatures(vm),
                            AddHotelPhotos(vm),
                            AddHotelRoom(vm),
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

  Widget _appbarBuilder(BuildContext context, AddNewHotelVm vm) {
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
        'Add New Hotel',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22.0,
        ),
      ),
    );
  }
}
