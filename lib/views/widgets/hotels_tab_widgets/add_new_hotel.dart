import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return VmProvider<AddNewHotelVm>(
      onInit: (vm) {
        featuresList.forEach((feature) {
          feature.isSelected = false;
        });

        if (widget.hotel != null) {
          vm.initializeHotelValues(widget.hotel);
        }
      },
      vm: AddNewHotelVm(),
      builder: (context, vm, appUser) {
        print(vm.rooms);
        return Scaffold(
          key: vm.hotelScaffoldKey,
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
                            'Publishing your hotel',
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
                            vm.isLoading
                                ? Container()
                                : RoundedBtn(
                                    title: 'Publish Hotel',
                                    onPressed: () {
                                      vm.isEditing
                                          ? vm.updateExistingHotel(
                                              context,
                                              appUser.uid,
                                              widget.hotel,
                                            )
                                          : vm.uploadNewHotel(
                                              context, appUser.uid);
                                    },
                                  ),
                            SizedBox(
                              height: 30.0,
                            ),
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
        if (vm.isEditing) {
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          Navigator.pop(context);
        }
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
