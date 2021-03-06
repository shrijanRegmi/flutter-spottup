import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:motel/enums/account_type.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/models/firebase/vehicle_model.dart';
import 'package:motel/viewmodels/hotel_view_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/screens/home/vehicle_book_screen.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';
import 'package:motel/views/widgets/common_widgets/star_ratings.dart';
import 'package:provider/provider.dart';

class ShortenedVehicleViewScreen extends StatelessWidget {
  final PageController pageController;
  final Vehicle vehicle;
  ShortenedVehicleViewScreen({
    this.pageController,
    this.vehicle,
  });

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return VmProvider<HotelViewVm>(
      vm: HotelViewVm(context: context),
      onInit: (vm) {
        bool _isFav = _appUser.favourite.contains(vehicle.id);
        vm.updateFavourite(_isFav);
      },
      builder: (context, vm, appUser) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(vehicle.dp),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _btnSection(context, vm, appUser),
              _bottomSection(appUser, context, vm),
            ],
          ),
        );
      },
    );
  }

  Widget _btnSection(BuildContext context, HotelViewVm vm, AppUser appUser) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 40.0,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: Icon(Icons.arrow_back_ios),
                ),
                backgroundColor: Colors.black87,
                heroTag: 'backBtn',
              ),
              if (appUser.accountType != AccountType.vehiclePartner)
                FloatingActionButton(
                  onPressed: () {
                    vm.updateFavourite(!vm.isFavourite);
                    vm.sendFavourite(vehicle.id, appUser);
                  },
                  child: Center(
                    child: Icon(
                      vm.isFavourite ? Icons.favorite : Icons.favorite_border,
                      color: Color(0xff45ad90),
                    ),
                  ),
                  backgroundColor: Colors.white,
                  heroTag: 'favBtn',
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bottomSection(
      final AppUser appUser, BuildContext context, HotelViewVm vm) {
    return Column(
      children: <Widget>[
        _detailSection(vm, context, appUser),
        _moreBtn(context),
        SizedBox(
          height: 30.0,
        ),
      ],
    );
  }

  Widget _detailSection(
      HotelViewVm vm, BuildContext context, final AppUser appUser) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    vehicle.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    'Model Year: ${vehicle.modelYear}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black26,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '${vehicle.seats} Seats',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                          color: Colors.black26,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      StarRatings(
                        ratings: 3.0,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Rs ${vehicle.price}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        '/per person',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black26,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              if (appUser.accountType != AccountType.vehiclePartner)
                RoundedBtn(
                  title: 'Book now',
                  padding: 0.0,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VehicleBookScreen(vehicle),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _moreBtn(BuildContext context) {
    return RoundedBtn(
      title: 'More details',
      color: Colors.white,
      textColor: Color(0xff45ad90),
      minWidth: 130.0,
      fontSize: 12.0,
      onPressed: () {
        pageController.animateTo(MediaQuery.of(context).size.height,
            duration: Duration(milliseconds: 1000), curve: Curves.ease);
      },
    );
  }
}
