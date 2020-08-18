import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:motel/views/screens/home/view_all_screen.dart';
import 'package:motel/views/widgets/common_widgets/left_right_text.dart';
import 'package:motel/views/widgets/hotel_view_widgets/hotel_photos_item.dart';

class HotelPhotosList extends StatelessWidget {
  final List<dynamic> photos;
  HotelPhotosList(this.photos);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        LeftRightText(
          leftText: 'Photos',
          rightText: '',
          requiredIcon: false,
          onPressIcon: photos.length <= 5
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ViewAllScreen(
                        title: 'All Photos',
                        isGrid: true,
                        list: photos,
                        listItem: (list, index) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            image: DecorationImage(
                              image: CachedNetworkImageProvider(photos[index]),
                              fit: BoxFit.cover,
                            ),
                            color: Colors.green[100]
                          ),
                        ),
                      ),
                    ),
                  );
                },
        ),
        SizedBox(
          height: 20.0,
        ),
        _photosList(context),
      ],
    );
  }

  Widget _photosList(BuildContext context) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: photos.length <= 5 ? photos.length : 5,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: HotelPhotosItem(photos[index]),
            );
          }
          return HotelPhotosItem(photos[index]);
        },
      ),
    );
  }
}
