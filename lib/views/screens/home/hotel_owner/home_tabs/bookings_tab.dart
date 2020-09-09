import 'package:flutter/material.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/viewmodels/booking_tab_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/screens/home/booking_tabs/contacted_booking_tab.dart';
import 'package:motel/views/screens/home/booking_tabs/new_booking_tab.dart';
import 'package:motel/views/screens/home/booking_tabs/other_booking_tab.dart';

class BookingsTab extends StatefulWidget {
  @override
  _BookingsTabState createState() => _BookingsTabState();
}

class _BookingsTabState extends State<BookingsTab>
    with SingleTickerProviderStateMixin {
  TabController _bookingsTabController;

  @override
  void initState() {
    super.initState();
    _bookingsTabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return VmProvider<BookingTabVm>(
      vm: BookingTabVm(context),
      builder: (context, vm, appUser) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              _titleBuilder(),
              _tabBarBuilder(context),
              _tabBarViewBuilder(appUser, vm),
            ],
          ),
        );
      },
    );
  }

  Widget _titleBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        'Bookings',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22.0,
        ),
      ),
    );
  }

  Widget _tabBarBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: TabBar(
          controller: _bookingsTabController,
          indicatorColor: Colors.transparent,
          unselectedLabelColor: Colors.black38,
          labelColor: Color(0xff45ad90),
          labelStyle: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            fontSize: 13.0,
          ),
          tabs: <Widget>[
            Tab(
              text: 'New',
            ),
            Tab(
              text: 'Other',
            ),
            Tab(
              text: 'Contacted',
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabBarViewBuilder(AppUser appUser, BookingTabVm vm) {
    return Expanded(
      child: TabBarView(
        controller: _bookingsTabController,
        children: _getTabs(appUser, vm),
      ),
    );
  }

  List<Widget> _getTabs(AppUser appUser, BookingTabVm vm) {
    return [
      NewBookingTab(vm.newBookings),
      OtherBookingTab(vm.otherBookings),
      ContactedBookingTab(vm.contactedBookings),
    ];
  }
}
