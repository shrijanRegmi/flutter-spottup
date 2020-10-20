import 'package:flutter/material.dart';
import 'package:motel/models/firebase/last_search_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/models/firebase/vehicle_model.dart';
import 'package:motel/services/firestore/user_provider.dart';
import 'package:motel/views/screens/home/vehicle_view_screen.dart';
import 'package:motel/views/widgets/common_widgets/star_ratings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class SearchResultListItemVehicle extends StatelessWidget {
  final Vehicle vehicle;
  SearchResultListItemVehicle(this.vehicle);

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => VehicleViewScreen(vehicle: vehicle)));

        final _lastSearch = LastSearch(
          hotelRef: vehicle.toRef(),
          lastUpdated: DateTime.now().millisecondsSinceEpoch,
        );
        UserProvider(uid: _appUser.uid).saveLastSearch(_lastSearch);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 250.0,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(3.0, 3.0),
                blurRadius: 10.0,
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10.0)),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                        vehicle.dp,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicle.name,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Model Year: ${vehicle.modelYear}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black26,
                            ),
                          ),
                          Text(
                            '${vehicle.seats} Seats',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black26,
                            ),
                          ),
                          Container(
                            width: 120.0,
                            child: StarRatings(
                              ratings: 3.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'Rs ${vehicle.price}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '/per night',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black26,
                              fontSize: 12.0),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
