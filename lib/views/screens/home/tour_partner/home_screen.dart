import 'package:flutter/material.dart';
import 'package:motel/services/firestore/firebase_messaging_provider.dart';
import 'package:motel/views/screens/home/home_tabs/notifications_tab.dart';
import 'package:motel/views/screens/home/home_tabs/profile_tab.dart';
import 'package:motel/views/screens/home/hotel_owner/home_tabs/bookings_tab.dart';
import 'package:motel/views/screens/home/tour_partner/home_tabs/tours_tab.dart';

class TourPartnerHomeScreen extends StatefulWidget {
  final String uid;
  TourPartnerHomeScreen(this.uid);

  @override
  _TourPartnerHomeScreenState createState() => _TourPartnerHomeScreenState();
}

class _TourPartnerHomeScreenState extends State<TourPartnerHomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final _tabs = [
    ToursTab(),
    BookingsTab(),
    NotificationsTab(),
    ProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    FirebaseMessagingProvider(context: context).configureMessaging();
    FirebaseMessagingProvider(uid: widget.uid).saveDevice();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _tabBarView(),
            _tabBar(),
          ],
        ),
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
            icon: Icon(Icons.map),
            iconMargin: const EdgeInsets.all(0.0),
            text: 'Tours',
          ),
          Tab(
            icon: Icon(Icons.book),
            iconMargin: const EdgeInsets.all(0.0),
            text: 'Bookings',
          ),
          Tab(
            icon: Icon(Icons.notifications),
            iconMargin: const EdgeInsets.all(0.0),
            text: 'Notifications',
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
