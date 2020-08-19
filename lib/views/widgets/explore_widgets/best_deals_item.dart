import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:motel/views/screens/home/hotel_view_screen.dart';
import 'package:motel/views/widgets/common_widgets/star_ratings.dart';
import 'package:motel/models/firebase/hotel_model.dart';

class BestDealItem extends StatelessWidget {
  final Hotel bestDeal;
  BestDealItem({this.bestDeal});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HotelViewScreen(hotel: bestDeal),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
        child: Container(
          height: 120.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(3.0, 3.0),
                blurRadius: 10.0,
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              _imgBuilder(),
              _detailsBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imgBuilder() {
    return Expanded(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(10.0),
              ),
              child: CachedNetworkImage(
                imageUrl: bestDeal.dp,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailsBuilder() {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  bestDeal.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  '${bestDeal.city}, ${bestDeal.country}',
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
                    Text(
                      bestDeal.rooms != 1
                          ? '${bestDeal.rooms} Rooms - ${bestDeal.persons} Adults'
                          : '${bestDeal.rooms} Room - ${bestDeal.persons} Adults',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.0,
                        color: Colors.black26,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    StarRatings(
                      ratings: bestDeal.stars,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      '\$${bestDeal.price}',
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
          ],
        ),
      ),
    );
  }
}
