import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:motel/helpers/date_helper.dart';
import 'package:motel/models/firebase/tour_model.dart';
import 'package:motel/views/screens/home/tour_view_screen.dart';
import 'package:motel/views/widgets/common_widgets/star_ratings.dart';

class TourViewListItem extends StatelessWidget {
  final Tour tour;
  final bool isEditing;
  TourViewListItem({
    this.tour,
    this.isEditing = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TourViewScreen(
              tour: tour,
              isEditing: isEditing,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0, left: 20.0, right: 20.0),
        child: Container(
          height: 140.0,
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
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      tour.dp,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
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
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    tour.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(
                    '${tour.days} days, ${tour.nights} nights',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black26,
                      fontSize: 12.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${DateHelper().getFormattedDate(tour.start)} - ${DateHelper().getFormattedDate(tour.end)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.0,
                                  color: Colors.black26,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          width: 100.0,
                          child: StarRatings(
                            ratings: 3.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          'Rs ${tour.price}',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          '/per person',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black26,
                            fontSize: 12.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
