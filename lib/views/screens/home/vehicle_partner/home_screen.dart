import 'package:flutter/material.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/firebase_messaging_provider.dart';
import 'package:motel/services/firestore/user_provider.dart';
import 'package:motel/views/screens/home/home_tabs/notifications_tab.dart';
import 'package:motel/views/screens/home/home_tabs/profile_tab.dart';
import 'package:motel/views/screens/home/hotel_owner/home_tabs/bookings_tab.dart';
import 'package:motel/views/screens/home/vehicle_partner/home_tabs/vehicles_tab.dart';
import 'package:provider/provider.dart';

class VehiclePartnerHomeScreen extends StatefulWidget {
  final String uid;
  VehiclePartnerHomeScreen(this.uid);

  @override
  _VehiclePartnerHomeScreenState createState() =>
      _VehiclePartnerHomeScreenState();
}

class _VehiclePartnerHomeScreenState extends State<VehiclePartnerHomeScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  final _tabs = [
    VehiclesTab(),
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
    final _appUser = Provider.of<AppUser>(context);
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
        onTap: (index) {
          if (index == 2) {
            UserProvider(uid: _appUser.uid, appUserRef: _appUser.toRef())
                .removeNotifCount();
          }
        },
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
            icon: Stack(
              overflow: Overflow.visible,
              children: [
                Icon(Icons.notifications),
                if (_appUser != null && _appUser.notifCount != 0)
                  Positioned(
                    right: -5.0,
                    top: -10.0,
                    child: Container(
                      padding: const EdgeInsets.all(6.0),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _appUser.notifCount > 9
                              ? '9+'
                              : '${_appUser.notifCount}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 10.0,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
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
