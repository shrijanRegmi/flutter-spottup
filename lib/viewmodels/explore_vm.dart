import 'package:flutter/material.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/popular_destination_model.dart';
import 'package:motel/models/firebase/top_three_model.dart';
import 'package:provider/provider.dart';

class ExploreVm extends ChangeNotifier {
  final BuildContext context;
  ExploreVm({@required this.context});

  List<Hotel> get hotelsList => Provider.of<List<Hotel>>(context) ?? [];
  List<TopThree> get topThree => Provider.of<List<TopThree>>(context) ?? [];
  List<PopularDestination> get popularDestinations =>
      Provider.of<List<PopularDestination>>(context) ?? [];
}
