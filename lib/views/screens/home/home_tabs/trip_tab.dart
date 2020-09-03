import 'package:flutter/material.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/viewmodels/trip_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/screens/home/trip_tabs/favourite_tab.dart';
import 'package:motel/views/screens/home/trip_tabs/upcoming_tab.dart';

class TripTab extends StatefulWidget {
  @override
  _TripTabState createState() => _TripTabState();
}

class _TripTabState extends State<TripTab> with SingleTickerProviderStateMixin {
  TabController _tripTabController;

  @override
  void initState() {
    super.initState();
    _tripTabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return VmProvider<TripVm>(
      vm: TripVm(),
      builder: (context, vm, appUser) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 40.0,
              ),
              _titleBuilder(),
              _tabBarBuilder(context),
              _tabBarViewBuilder(appUser),
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
        'My trips',
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
          controller: _tripTabController,
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
              text: 'Upcoming',
            ),
            // Tab(
            //   text: 'Finished',
            // ),
            Tab(
              text: 'Favourite',
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabBarViewBuilder(AppUser appUser) {
    return Expanded(
      child: TabBarView(
        controller: _tripTabController,
        children: _getTabs(appUser),
      ),
    );
  }

  List<Widget> _getTabs(AppUser appUser) {
    return [
      UpcomingTab(),
      // FinishedTab(appUser.finished),
      FavouriteTab(appUser.favourite),
    ];
  }
}
