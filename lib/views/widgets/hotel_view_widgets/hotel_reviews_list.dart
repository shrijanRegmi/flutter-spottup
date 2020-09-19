import 'package:flutter/material.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/review_model.dart';
import 'package:motel/services/firestore/review_provider.dart';
import 'package:motel/views/screens/home/write_review_screen.dart';
import 'package:motel/views/widgets/common_widgets/left_right_text.dart';
import 'package:motel/views/widgets/hotel_view_widgets/hotel_review_item.dart';

class HotelReviewsList extends StatelessWidget {
  final Hotel hotel;
  HotelReviewsList(this.hotel);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        LeftRightText(
          leftText: 'Reviews (${hotel.reviews})',
          rightText: '',
          requiredIcon: false,
        ),
        _reviewsList(context),
      ],
    );
  }

  Widget _reviewsList(BuildContext context) {
    return StreamBuilder<List<Review>>(
      stream: ReviewProvider(hotelId: hotel.id).reviewsList,
      builder: (context, reviewSnap) {
        if (reviewSnap.hasData) {
          final List<Review> _reviews = reviewSnap.data;
          return Column(
            children: [
              _writeReviewBuilder(context),
              ListView.builder(
                itemCount: _reviews.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return HotelReviewItem(
                    _reviews[index],
                  );
                },
              ),
            ],
          );
        }
        return Container();
      },
    );
  }

  Widget _writeReviewBuilder(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WriteReviewScreen(hotel.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border(
            bottom: BorderSide(
              color: Color(0xff45ad90),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Write Review',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Color(0xff45ad90),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
