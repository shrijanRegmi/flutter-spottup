import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motel/enums/analytics_status.dart';
import 'package:motel/models/firebase/user_model.dart';

class AnalyticUserListItem extends StatelessWidget {
  final AppUser user;
  AnalyticUserListItem(this.user);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
      child: Row(
        children: [
          user.photoUrl == null
              ? Center(
                  child: SvgPicture.asset(
                    'assets/svgs/upload_img.svg',
                    width: 40.0,
                    height: 40.0,
                  ),
                )
              : CircleAvatar(
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
              color: user.analyticStatus == AnalyticStatus.booked
                  ? Color(0xff45ad90).withOpacity(0.1)
                  : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              user.analyticStatus == AnalyticStatus.booked
                  ? 'Booked'
                  : 'Not booked yet',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: user.analyticStatus == AnalyticStatus.booked
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
