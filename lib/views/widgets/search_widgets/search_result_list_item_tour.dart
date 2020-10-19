import 'package:flutter/material.dart';
import 'package:motel/helpers/date_helper.dart';
import 'package:motel/models/firebase/last_search_model.dart';
import 'package:motel/models/firebase/tour_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/user_provider.dart';
import 'package:motel/views/screens/home/tour_view_screen.dart';
import 'package:motel/views/widgets/common_widgets/star_ratings.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

class SearchResultListItemTour extends StatelessWidget {
  final Tour tour;
  SearchResultListItemTour(this.tour);

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => TourViewScreen(tour: tour)));

        final _lastSearch = LastSearch(
          hotelRef: tour.toRef(),
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
                        tour.dp,
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
                            tour.name,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${tour.days} days, ${tour.nights} nights',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black26,
                            ),
                          ),
                          Text(
                            '${DateHelper().getFormattedDate(tour.start)} - ${DateHelper().getFormattedDate(tour.end)}',
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
                          'Rs ${tour.price}',
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
