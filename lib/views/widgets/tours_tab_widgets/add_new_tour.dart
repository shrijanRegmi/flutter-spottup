import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:motel/models/app/hotel_features.dart';
import 'package:motel/models/app/tour_types.dart';
import 'package:motel/models/firebase/tour_model.dart';
import 'package:motel/viewmodels/add_new_tour_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/widgets/add_new_tour_widgets/add_tour_details.dart';
import 'package:motel/views/widgets/add_new_tour_widgets/add_tour_photos.dart';
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
    return VmProvider<AddNewTourVm>(
      onInit: (vm) {
        featuresList.forEach((feature) {
          feature.isSelected = false;
        });

        if (widget.tour != null) {
          vm.initializeTourValues(widget.tour);
        }
      },
      vm: AddNewTourVm(context),
      builder: (context, vm, appUser) {
        return Scaffold(
          key: vm.scaffoldKey,
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
                            _tourTypeBuilder(vm),
                            SizedBox(
                              height: 20.0,
                            ),
                            AddTourDetails(vm),
                            AddTourPhotos(vm, widget.tour),
                            vm.isLoading
                                ? Container()
                                : RoundedBtn(
                                    title: widget.tour == null
                                        ? 'Publish Tour'
                                        : 'Update Tour',
                                    onPressed: () {
                                      widget.tour == null
                                          ? vm.publishTour(appUser)
                                          : vm.updateTour(
                                              appUser,
                                              widget.tour.id,
                                            );
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

  Widget _appbarBuilder(BuildContext context, AddNewTourVm vm) {
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
        widget.tour == null ? 'Add New Tour' : 'Edit Tour',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22.0,
        ),
      ),
    );
  }

  Widget _tourTypeBuilder(final AddNewTourVm vm) {
    final _items = <TourType>[TourType.date, TourType.weekly];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add tour type',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.0,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          DropdownButton(
            items: _items
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(
                      '${Tour().getTourTypeTitle(e)}',
                    ),
                  ),
                )
                .toList(),
            underline: Container(),
            value: vm.selectedTourType,
            onChanged: (val) {
              vm.updateSelectedTourType(val);
            },
          ),
        ],
      ),
    );
  }
}
