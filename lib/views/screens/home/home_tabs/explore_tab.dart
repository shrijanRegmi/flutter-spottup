import 'dart:async';

import 'package:flutter/material.dart';
import 'package:motel/views/screens/home/search_screen.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';
import 'package:motel/views/widgets/explore_widgets/best_deals.dart';
import 'package:motel/views/widgets/explore_widgets/popular_destination.dart';

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
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _topSection(context),
            SizedBox(
              height: 40.0,
            ),
            PopularDestinations(),
            SizedBox(
              height: 40.0,
            ),
            BestDeals(),
          ],
        ),
      ),
    );
  }

  Widget _topSection(BuildContext context) {
    return Stack(
      children: <Widget>[
        _popularDestination(context),
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

  Widget _popularDestination(BuildContext context) {
    return Container(
      height: 400.0,
      child: PageView(
        controller: _controller,
        children: <Widget>[
          _popularDestinationItem(
            context,
            'assets/images/cape_town.jpg',
            'Cape Town',
            'Extraordinary five-star\noutdoor activities',
            () {},
          ),
          _popularDestinationItem(
            context,
            'assets/images/cape_town.jpg',
            'London',
            'Extraordinary five-star\noutdoor activities',
            () {},
          ),
          _popularDestinationItem(
            context,
            'assets/images/cape_town.jpg',
            'Paris',
            'Extraordinary five-star\noutdoor activities',
            () {},
          ),
        ],
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
              image: AssetImage(_img),
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
