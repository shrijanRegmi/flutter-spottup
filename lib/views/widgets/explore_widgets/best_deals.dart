import 'package:flutter/material.dart';
import 'package:motel/views/widgets/explore_widgets/best_deals_item.dart';

class BestDeals extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _textBuilder(),
        _bestDealsList(),
      ],
    );
  }

  Widget _textBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Best deals',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16.0,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: <Widget>[
                Text(
                  'View all',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                    color: Color(0xff45ad90),
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Icon(
                  Icons.arrow_forward,
                  color: Color(0xff45ad90),
                  size: 18.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bestDealsList() {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return BestDealItem();
      },
    );
  }
}
