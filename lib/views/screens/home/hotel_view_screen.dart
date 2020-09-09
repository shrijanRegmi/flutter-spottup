import 'package:flutter/material.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/views/widgets/hotel_view_widgets/expanded_hotel_view_screen.dart';
import 'package:motel/views/widgets/hotel_view_widgets/shortened_hotel_view_screen.dart';

class HotelViewScreen extends StatefulWidget {
  @override
  _HotelViewScreenState createState() => _HotelViewScreenState();
  final Hotel hotel;
  final bool isEditing;
  HotelViewScreen({this.hotel, this.isEditing = false});
}

class _HotelViewScreenState extends State<HotelViewScreen> {
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: <Widget>[
          ShortenedHotelViewScreen(
            pageController: _pageController,
            hotel: widget.hotel,
            isEditing: widget.isEditing,
          ),
          ExpandedHotelViewScreen(
            pageController: _pageController,
            hotel: widget.hotel,
            isEditing: widget.isEditing,
          ),
        ],
      ),
    );
  }
}
