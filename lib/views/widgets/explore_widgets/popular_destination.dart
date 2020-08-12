import 'package:flutter/material.dart';
import 'package:motel/models/firebase/popular_destination_model.dart';
import 'package:motel/views/widgets/explore_widgets/popular_destination_item.dart';

class PopularDestinations extends StatelessWidget {
  final List<PopularDestination> popularDestination;
  PopularDestinations(this.popularDestination);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _textBuilder(),
        SizedBox(
          height: 20.0,
        ),
        _popularDestinationList(context),
      ],
    );
  }

  Widget _textBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        'Popular destinations',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16.0,
        ),
      ),
    );
  }

  Widget _popularDestinationList(BuildContext context) {
    return Container(
      height: 130.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: popularDestination.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: PopularDestinationItem(popularDestination[index]),
            );
          }
          return PopularDestinationItem(popularDestination[index]);
        },
      ),
    );
  }
}
