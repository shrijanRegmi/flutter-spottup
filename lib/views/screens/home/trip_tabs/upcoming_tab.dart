import 'package:flutter/material.dart';
import 'package:motel/views/widgets/explore_widgets/best_deals_item.dart';

class UpcomingTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Column(
            children: <Widget>[
              Text(
                '01 Oct - 07 Oct, 1 Room - 2 Adult',
                style: TextStyle(
                  fontSize: 12.0,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              BestDealItem(),
            ],
          ),
        );
      },
    );
  }
}
