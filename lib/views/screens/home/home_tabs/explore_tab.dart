import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:motel/enums/account_type.dart';
import 'package:motel/enums/booking_for_type.dart';
import 'package:motel/services/firestore/hotel_provider.dart';
import 'package:motel/views/screens/home/search_result_screen.dart';
import 'package:motel/views/screens/home/search_screen.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';
import 'package:motel/views/widgets/common_widgets/service_selector.dart';
import 'package:motel/views/widgets/explore_widgets/best_deals.dart';
import 'package:motel/views/widgets/explore_widgets/best_deals_tours.dart';
import 'package:motel/views/widgets/explore_widgets/best_deals_vehicles.dart';
import 'package:motel/views/widgets/explore_widgets/popular_destination.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/viewmodels/explore_vm.dart';

class ExploreTab extends StatefulWidget {
  @override
  _ExploreTabState createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  int _index = 0;
  PageController _controller;
  Timer _timer;
  int _pos = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _timer = Timer.periodic(Duration(milliseconds: 5000), (timer) {
      setState(() {
        _pos++;
        if (_pos == 3) {
          _controller.jumpTo(0);
          _pos = 0;
        } else {
          _controller.animateTo(MediaQuery.of(context).size.width * _pos,
              duration: Duration(milliseconds: 500), curve: Curves.linear);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return VmProvider<ExploreVm>(
        vm: ExploreVm(context: context),
        builder: (context, vm, appUser) {
          return Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _topSection(context, vm),
                  SizedBox(
                    height: 40.0,
                  ),
                  PopularDestinations(vm.popularDestinations),
                  SizedBox(
                    height: 40.0,
                  ),
                  ServiceSelector(onSelected: vm.updateServiceValue),
                  SizedBox(
                    height: 40.0,
                  ),
                  if (vm.hotelsList.isNotEmpty &&
                      vm.service == BookingForType.hotel)
                    BestDeals(vm.hotelsList),
                  if (vm.hotelsList.isNotEmpty &&
                      vm.service == BookingForType.hotel)
                    SizedBox(
                      height: 30.0,
                    ),
                  if (vm.toursList.isNotEmpty &&
                      vm.service == BookingForType.tour)
                    BestTourDeals(vm.toursList),
                  if (vm.toursList.isNotEmpty &&
                      vm.service == BookingForType.tour)
                    SizedBox(
                      height: 30.0,
                    ),
                  if (vm.vehiclesList.isNotEmpty &&
                      vm.service == BookingForType.vehicle)
                    BestVehicleDeals(vm.vehiclesList),
                ],
              ),
            ),
          );
        });
  }

  Widget _topSection(BuildContext context, ExploreVm vm) {
    return Stack(
      children: <Widget>[
        _popularDestination(context, vm),
        _searchBuilder(),
        Positioned(
          bottom: 10.0,
          right: 10.0,
          child: _circularPositionBuilder(),
        ),
      ],
    );
  }

  Widget _searchBuilder() {
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 10.0, right: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SearchScreen(),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(3.0, 3.0),
                blurRadius: 10.0,
              ),
            ],
            borderRadius: BorderRadius.circular(100.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              enabled: false,
              style: TextStyle(
                fontSize: 14.0,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Where are you going?',
                contentPadding: const EdgeInsets.only(top: 15.0),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xff45ad90),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _popularDestination(BuildContext context, ExploreVm vm) {
    return Container(
      height: 400.0,
      child: PageView.builder(
        controller: _controller,
        itemCount: vm.topThree.length,
        itemBuilder: (context, index) {
          return _popularDestinationItem(
            context,
            vm.topThree[index].dp,
            vm.topThree[index].name,
            vm.topThree[index].details,
            () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SearchResultScreen(
                  HotelProvider(
                    city: vm.topThree[index].name,
                  ).searchedHotelsFromCity,
                  vm.topThree[index].name,
                  AccountType.hotelPartner,
                ),
              ),
            ),
          );
        },
        onPageChanged: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }

  Widget _popularDestinationItem(
    final BuildContext context,
    final String _img,
    final String _title,
    final String _detail,
    final Function _callBack,
  ) {
    return Stack(
      children: <Widget>[
        Container(
          height: 400.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(_img),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 400.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black87,
                ]),
          ),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      _title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      _detail,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.0,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    RoundedBtn(
                      title: 'View Hotels',
                      padding: 0.0,
                      minWidth: 0.0,
                      horizontalTextSpacing: 25.0,
                      fontSize: 12.0,
                      onPressed: _callBack,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _circularPositionBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        CircleAvatar(
          maxRadius: 4.0,
          backgroundColor: _index == 0 ? Color(0xff45ad90) : Colors.grey[200],
        ),
        SizedBox(
          width: 5.0,
        ),
        CircleAvatar(
          maxRadius: 4.0,
          backgroundColor: _index == 1 ? Color(0xff45ad90) : Colors.grey[200],
        ),
        SizedBox(
          width: 5.0,
        ),
        CircleAvatar(
          maxRadius: 4.0,
          backgroundColor: _index == 2 ? Color(0xff45ad90) : Colors.grey[200],
        ),
      ],
    );
  }
}
