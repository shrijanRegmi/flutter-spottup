import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';
import 'package:motel/views/widgets/common_widgets/star_ratings.dart';

class HotelViewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/welcome_img.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _btnSection(context),
            _bottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _btnSection(BuildContext context) {
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
              FloatingActionButton(
                onPressed: () {},
                child: Center(
                  child: Icon(
                    Icons.favorite_border,
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

  Widget _bottomSection() {
    return Column(
      children: <Widget>[
        _detailSection(),
        _moreBtn(),
        SizedBox(
          height: 30.0,
        ),
      ],
    );
  }

  Widget _detailSection() {
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
                    'Grand Royal Hotel',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20.0,
                    ),
                  ),
                  Text(
                    'Wembly London',
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
                      SizedBox(
                        height: 5.0,
                      ),
                      StarRatings(
                        ratings: 4,
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
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        '/per night',
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
              RoundedBtn(
                title: 'Book now',
                padding: 0.0,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _moreBtn() {
    return RoundedBtn(
      title: 'More details',
      color: Colors.white,
      textColor: Color(0xff45ad90),
      minWidth: 130.0,
      fontSize: 12.0,
      onPressed: () {},
    );
  }
}
