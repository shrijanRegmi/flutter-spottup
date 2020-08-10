import 'package:flutter/material.dart';

class StarRatings extends StatelessWidget {
  final double ratings;
  final double size;
  StarRatings({
    @required this.ratings,
    this.size = 20.0,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _getRatings(),
      ),
    );
  }

  List<Widget> _getRatings() {
    List<Widget> _ratingsList = [];
    for (int i = 0; i < 5; i++) {
      _ratingsList.add(Icon(
        Icons.star,
        size: size,
        color: i < ratings ? Color(0xff45ad90) : Colors.black12,
      ));
    }
    return _ratingsList;
  }
}
