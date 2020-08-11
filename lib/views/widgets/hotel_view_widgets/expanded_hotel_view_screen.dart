import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';
import 'package:motel/views/widgets/hotel_view_widgets/hotel_reviews_list.dart';

import 'hotel_photos_list.dart';

class ExpandedHotelViewScreen extends StatefulWidget {
  final PageController pageController;
  ExpandedHotelViewScreen({this.pageController});

  @override
  _ExpandedHotelViewScreenState createState() =>
      _ExpandedHotelViewScreenState();
}

class _ExpandedHotelViewScreenState extends State<ExpandedHotelViewScreen> {
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    KeyboardVisibility.onChange.listen((visibility) {
      setState(() {
        _isKeyboardVisible = visibility;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _topSection(context),
              SizedBox(
                height: 20.0,
              ),
              _hotelDetailBuilder(),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Divider(),
              ),
              _summaryBuilder(),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Divider(),
              ),
              HotelPhotosList(),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: Divider(),
              ),
              HotelReviewsList(),
              SizedBox(
                height: 50.0,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: !_isKeyboardVisible
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: RoundedBtn(
                title: 'Book now',
                padding: 0.0,
                onPressed: () {},
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _topSection(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: 200.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/welcome_img.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        _btnSection(context),
      ],
    );
  }

  Widget _btnSection(BuildContext context) {
    final _size = 50.0;
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
              Container(
                width: _size,
                height: _size,
                child: FloatingActionButton(
                  onPressed: () {
                    widget.pageController.animateTo(-1,
                        duration: Duration(milliseconds: 1000),
                        curve: Curves.ease);
                  },
                  child: Center(
                    child: Icon(Icons.arrow_back_ios),
                  ),
                  backgroundColor: Colors.black87,
                  heroTag: 'backBtn2',
                ),
              ),
              Container(
                width: _size,
                height: _size,
                child: FloatingActionButton(
                  onPressed: () {},
                  child: Center(
                    child: Icon(
                      Icons.favorite_border,
                      color: Color(0xff45ad90),
                    ),
                  ),
                  backgroundColor: Colors.white,
                  heroTag: 'favBtn2',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _hotelDetailBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Grand Royal Hotel',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22.0,
                ),
              ),
              Text(
                'Wembley, London',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black26,
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            Icons.location_on,
                            color: Color(0xff45ad90),
                            size: 18.0,
                          ),
                          Text(
                            '4 Km from city',
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
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '\$120',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 22.0,
                ),
              ),
              Text(
                '/per night',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.black26,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Summary',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident.',
            style: TextStyle(
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}
