import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:motel/enums/analytics_status.dart';
import 'package:motel/models/firebase/user_model.dart';

class AnalyticUserListItem extends StatelessWidget {
  final AppUser user;
  final AnalyticStatus status;
  AnalyticUserListItem(this.user, this.status);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              user.photoUrl,
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${user.firstName} ${user.lastName}',
                ),
                Text(
                  '${user.email}',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black26,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: status == AnalyticStatus.booked
                  ? Color(0xff45ad90).withOpacity(0.1)
                  : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              status == AnalyticStatus.booked ? 'Booked' : 'Not booked yet',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: status == AnalyticStatus.booked
                    ? Color(0xff45ad90)
                    : Colors.black38,
                fontSize: 12.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
