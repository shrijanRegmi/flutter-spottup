import 'package:flutter/material.dart';
import 'package:motel/views/widgets/common_widgets/left_right_text.dart';
import 'package:motel/views/widgets/search_widgets/last_searches_item.dart';

class LastSearchesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          LeftRightText(
            leftText: 'Last searches',
            rightText: 'Clear all',
            requiredIcon: false,
            onPressIcon: () {},
          ),
          SizedBox(
            height: 20.0,
          ),
          _lastSearchesList(),
        ],
      ),
    );
  }

  Widget _lastSearchesList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GridView.builder(
        itemCount: 5,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
          childAspectRatio: 2/3,
        ),
        itemBuilder: (context, index) {
          return LastSearchesItem();
        },
      ),
    );
  }
}
