import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:motel/models/firebase/popular_destination_model.dart';
import 'package:motel/views/screens/home/search_result_screen.dart';

class PopularDestinationItem extends StatelessWidget {
  final PopularDestination popularDestination;
  PopularDestinationItem(this.popularDestination);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SearchResultScreen(popularDestination.name),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Stack(
          children: <Widget>[
            Container(
              width: 230.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(popularDestination.dp),
                  fit: BoxFit.cover,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Container(
              width: 230.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black38,
                    Colors.transparent,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    popularDestination.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
