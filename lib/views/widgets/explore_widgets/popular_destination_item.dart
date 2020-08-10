import 'package:flutter/material.dart';

class PopularDestinationItem extends StatelessWidget {
  final String title;
  final String imgPath;
  PopularDestinationItem({this.title, this.imgPath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: Stack(
        children: <Widget>[
          Container(
            width: 230.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: AssetImage('assets/images/welcome_img.jpg'),
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
                  'Paris',
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
    );
  }
}
