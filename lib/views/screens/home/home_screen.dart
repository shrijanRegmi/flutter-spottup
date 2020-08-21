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

  // final List<Map<String, dynamic>> _datas = [
  //   {
  //     'name': 'Grand Royal Hotel',
  //     'city': 'London',
  //     'country': 'United Kingdom',
  //     'stars': 4.0,
  //     'price': 120,
  //     'summary':
  //         'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
  //     'photos': [],
  //     'reviews': [],
  //     'rooms': [],
  //     'persons': 4,
  //     'type': 0,
  //     'is_best_deal': false,
  //   },
  //   {
  //     'name': 'Alhambra Hotel',
  //     'city': 'Paris',
  //     'country': 'Italy',
  //     'stars': 2.0,
  //     'price': 463,
  //     'summary':
  //         'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
  //     'photos': [],
  //     'reviews': [],
  //     'rooms': [],
  //     'persons': 1,
  //     'type': 0,
  //     'is_best_deal': false,
  //   },
  //   {
  //     'name': 'The Hoxton Holborn',
  //     'city': 'London',
  //     'country': 'United Kingdom',
  //     'stars': 3.0,
  //     'price': 104,
  //     'summary':
  //         'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
  //     'photos': [],
  //     'reviews': [],
  //     'rooms': [],
  //     'persons': 5,
  //     'type': 0,
  //     'is_best_deal': false,
  //   },
  //   {
  //     'name': 'The Tower Hotel',
  //     'city': 'Kathmandu',
  //     'country': 'Nepal',
  //     'stars': 5.0,
  //     'price': 200,
  //     'summary':
  //         'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
  //     'photos': [],
  //     'reviews': [],
  //     'rooms': [],
  //     'persons': 3,
  //     'type': 0,
  //     'is_best_deal': false,
  //   },
  //   {
  //     'name': 'Garden Court Hotel',
  //     'city': 'Romatica',
  //     'country': 'Russia',
  //     'stars': 4.0,
  //     'price': 120,
  //     'summary':
  //         'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
  //     'photos': [],
  //     'reviews': [],
  //     'rooms': [],
  //     'persons': 4,
  //     'type': 0,
  //     'is_best_deal': false,
  //   },
  //   {
  //     'name': 'The Resident Covent Garden',
  //     'city': 'London',
  //     'country': 'United Kingdom',
  //     'stars': 5.0,
  //     'price': 670,
  //     'summary':
  //         'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
  //     'photos': [],
  //     'reviews': [],
  //     'rooms': [],
  //     'persons': 4,
  //     'type': 0,
  //     'is_best_deal': false,
  //   },
  //   {
  //     'name': 'NOX Hotel',
  //     'city': 'London',
  //     'country': 'United Kingdom',
  //     'stars': 3.0,
  //     'price': 320,
  //     'summary':
  //         'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
  //     'photos': [],
  //     'reviews': [],
  //     'rooms': [],
  //     'persons': 1,
  //     'type': 0,
  //     'is_best_deal': false,
  //   },
  //   {
  //     'name': 'Paddington Park Hotel',
  //     'city': 'London',
  //     'country': 'United Kingdom',
  //     'stars': 5.0,
  //     'price': 670,
  //     'summary':
  //         'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
  //     'photos': [],
  //     'reviews': [],
  //     'rooms': [],
  //     'persons': 4,
  //     'type': 0,
  //     'is_best_deal': false,
  //   },
  //   {
  //     'name': 'The Royal Horseguards',
  //     'city': 'London',
  //     'country': 'United Kingdom',
  //     'stars': 2.0,
  //     'price': 90,
  //     'summary':
  //         'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
  //     'photos': [],
  //     'reviews': [],
  //     'rooms': [],
  //     'persons': 9,
  //     'type': 0,
  //     'is_best_deal': false,
  //   },
  //   {
  //     'name': 'Amba Hotel Marble Arch',
  //     'city': 'London',
  //     'country': 'United Kingdom',
  //     'stars': 5.0,
  //     'price': 120,
  //     'summary':
  //         'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.',
  //     'photos': [],
  //     'reviews': [],
  //     'rooms': [],
  //     'persons': 8,
  //     'type': 0,
  //     'is_best_deal': false,
  //   },
  // ];

  // final _ref = Firestore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Future.delayed(Duration(milliseconds: 500), _sendHotels);
  }

  // Future _sendHotels() async {
  //   for (var data in _datas) {
  //     print(data);
  //     await _ref.collection('hotels').add(data);
  //   }
  // }

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
