import 'package:flutter/material.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/views/widgets/analytics_widgets/analytics_users_list_item.dart';

class AnalyticsUsersList extends StatelessWidget {
  final List<AppUser> usersList;
  AnalyticsUsersList(this.usersList);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: usersList.length,
      itemBuilder: (context, index) {
        return AnalyticUserListItem(usersList[index]);
      },
    );
  }
}
