import 'package:flutter/material.dart';
import 'package:motel/enums/booking_for_type.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/popular_destination_model.dart';
import 'package:motel/models/firebase/top_three_model.dart';
import 'package:motel/models/firebase/tour_model.dart';
import 'package:motel/models/firebase/vehicle_model.dart';
import 'package:provider/provider.dart';

class ExploreVm extends ChangeNotifier {
  final BuildContext context;
  ExploreVm({@required this.context});

  BookingForType _service = BookingForType.hotel;

  List<Hotel> get hotelsList => Provider.of<List<Hotel>>(context) ?? [];
  List<Tour> get toursList => Provider.of<List<Tour>>(context) ?? [];
  List<Vehicle> get vehiclesList => Provider.of<List<Vehicle>>(context) ?? [];
  List<TopThree> get topThree => Provider.of<List<TopThree>>(context) ?? [];
  List<PopularDestination> get popularDestinations =>
      Provider.of<List<PopularDestination>>(context) ?? [];
  BookingForType get service => _service;

  // update value of service
  updateServiceValue(final BookingForType newService) {
    _service = newService;
    notifyListeners();
  }
}
