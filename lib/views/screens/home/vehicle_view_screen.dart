import 'package:flutter/material.dart';
import 'package:motel/models/firebase/vehicle_model.dart';
import 'package:motel/views/widgets/vehicle_view_widgets/expanded_vehicle_view_screen.dart';
import 'package:motel/views/widgets/vehicle_view_widgets/shortened_vehicle_view_screen.dart';

class VehicleViewScreen extends StatefulWidget {
  @override
  _VehicleViewScreenState createState() => _VehicleViewScreenState();
  final Vehicle vehicle;
  final bool isEditinig;
  VehicleViewScreen({
    this.vehicle,
    this.isEditinig = false,
  });
}

class _VehicleViewScreenState extends State<VehicleViewScreen> {
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
          ShortenedVehicleViewScreen(
            pageController: _pageController,
            vehicle: widget.vehicle,
          ),
          ExpandedVehicleViewScreen(
            pageController: _pageController,
            vehicle: widget.vehicle,
            isEditing: widget.isEditinig,
          ),
        ],
      ),
    );
  }
}
