import 'package:flutter/material.dart';
import 'package:motel/models/firebase/tour_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/tour_provider.dart';
import 'package:motel/views/widgets/common_widgets/left_right_text.dart';
import 'package:motel/views/widgets/tour_view_widgets/tour_view_list_item.dart';
import 'package:provider/provider.dart';

class PartnerToursList extends StatelessWidget {
  final bool isEditing;
  PartnerToursList({this.isEditing = false});

  @override
  Widget build(BuildContext context) {
    final _appUser = Provider.of<AppUser>(context);
    return Column(
      children: [
        LeftRightText(
          leftText: 'My Tours',
          rightText: '',
          requiredIcon: false,
        ),
        SizedBox(
          height: 20.0,
        ),
        StreamBuilder<List<Tour>>(
            stream: TourProvider(appUser: _appUser).myTours,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final _tours = snapshot.data;
                return _tours.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 50.0),
                        child: Text(
                          "You don't have any tours currently. Tap on 'Add a new tour' to add a tour",
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : ListView.builder(
                        itemCount: _tours.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return TourViewListItem(
                            tour: _tours[index],
                            isEditing: isEditing,
                          );
                        },
                      );
              }
              return Container();
            }),
      ],
    );
  }
}
