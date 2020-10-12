import 'package:flutter/material.dart';
import 'package:motel/models/firebase/tour_model.dart';
import 'package:motel/views/widgets/tour_view_widgets/expanded_tour_view_screen.dart';
import 'package:motel/views/widgets/tour_view_widgets/shortened_tour_view_screen.dart';

class TourViewScreen extends StatefulWidget {
  @override
  _TourViewScreenState createState() => _TourViewScreenState();
  final Tour tour;
  TourViewScreen({this.tour});
}

class _TourViewScreenState extends State<TourViewScreen> {
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
          ShortenedTourViewScreen(
            pageController: _pageController,
            tour: widget.tour,
          ),
          ExpandedTourViewScreen(
            pageController: _pageController,
            tour: widget.tour,
          ),
        ],
      ),
    );
  }
}
