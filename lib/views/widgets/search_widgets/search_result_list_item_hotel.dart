import 'package:flutter/material.dart';
import 'package:motel/models/firebase/last_search_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/user_provider.dart';
import 'package:motel/views/widgets/common_widgets/star_ratings.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:motel/views/screens/home/hotel_view_screen.dart';
import 'package:provider/provider.dart';

class SearchResultListItem extends StatelessWidget {
  final Hotel hotel;
  SearchResultListItem(this.hotel);

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => HotelViewScreen(hotel: hotel)));

        final _lastSearch = LastSearch(
          hotelRef: hotel.toRef(),
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
                        hotel.dp,
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
                            hotel.name,
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${hotel.city}, ${hotel.country}',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black26,
                            ),
                          ),
                          Text(
                            hotel.rooms != 1
                                ? '${hotel.rooms} Rooms - ${hotel.adults} Adults'
                                : '${hotel.rooms} Room - ${hotel.adults} Adults',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black26,
                            ),
                          ),
                          Container(
                            width: 120.0,
                            child: StarRatings(
                              ratings: hotel.stars,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'Rs ${hotel.getPrice()}',
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
