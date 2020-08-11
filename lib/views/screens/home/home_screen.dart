import 'package:flutter/material.dart';
import 'package:motel/views/screens/home/home_tabs/explore_tab.dart';
import 'package:motel/views/screens/home/home_tabs/profile_tab.dart';
import 'package:motel/views/screens/home/home_tabs/trip_tab.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  final _tabs = [
    ExploreTab(),
    TripTab(),
    ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _tabBarView(),
          _tabBar(),
        ],
      ),
    );
  }

  Widget _tabBarView() {
    return Expanded(
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: _tabs,
      ),
    );
  }

  Widget _tabBar() {
    return Container(
      height: 70.0,
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0.0, -5.0),
            blurRadius: 10.0,
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.transparent,
        unselectedLabelColor: Colors.black38,
        labelColor: Color(0xff45ad90),
        labelStyle: TextStyle(
          fontFamily: 'Nunito',
          fontWeight: FontWeight.bold,
        ),
        tabs: <Widget>[
          Tab(
            icon: Icon(Icons.search),
            iconMargin: const EdgeInsets.all(0.0),
            text: 'Explore',
          ),
          Tab(
            icon: Icon(Icons.favorite_border),
            iconMargin: const EdgeInsets.all(0.0),
            text: 'Trips',
          ),
          Tab(
            icon: Icon(Icons.perm_identity),
            iconMargin: const EdgeInsets.all(0.0),
            text: 'Profile',
          ),
        ],
      ),
    );
  }
}
