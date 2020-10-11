import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:motel/models/app/hotel_features.dart';
import 'package:motel/models/firebase/tour_model.dart';
import 'package:motel/viewmodels/add_new_hotel_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/widgets/add_new_hotel_widgets/add_hotel_details.dart';
import 'package:motel/views/widgets/add_new_hotel_widgets/add_hotel_features.dart';
import 'package:motel/views/widgets/add_new_hotel_widgets/add_hotel_photos.dart';
import 'package:motel/views/widgets/add_new_hotel_widgets/add_hotel_room.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';

class AddNewTour extends StatefulWidget {
  final Tour tour;
  AddNewTour({this.tour});

  @override
  _AddNewHotelState createState() => _AddNewHotelState();
}

class _AddNewHotelState extends State<AddNewTour> {
  @override
  Widget build(BuildContext context) {
    return VmProvider<AddNewHotelVm>(
      onInit: (vm) {
        featuresList.forEach((feature) {
          feature.isSelected = false;
        });

        if (widget.tour != null) {
          // vm.initializeHotelValues(widget.tour);
        }
      },
      vm: AddNewHotelVm(),
      builder: (context, vm, appUser) {
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
                            'Publishing your tour',
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
                                    title: 'Publish Tour',
                                    onPressed: () {
                                      // vm.isEditing
                                      //     ? vm.updateExistingHotel(
                                      //         context,
                                      //         appUser.uid,
                                      //         widget.tour,
                                      //       )
                                      //     : vm.uploadNewHotel(
                                      //         context, appUser.uid);
                                      // ;
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
        'Add New Tour',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22.0,
        ),
      ),
    );
  }
}
