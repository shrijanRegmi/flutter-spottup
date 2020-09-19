import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motel/models/firebase/review_model.dart';
import 'package:motel/views/widgets/common_widgets/star_ratings.dart';
import 'package:timeago/timeago.dart' as timeago;

class HotelReviewItem extends StatefulWidget {
  final Review review;
  HotelReviewItem(this.review);

  @override
  _HotelReviewItemState createState() => _HotelReviewItemState();
}

class _HotelReviewItemState extends State<HotelReviewItem> {
  bool _isReplying = false;
  FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 20.0,
            left: 20.0,
            right: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _userDetailBuilder(),
              SizedBox(
                height: 10.0,
              ),
              _reviewTextBuilder(),
              SizedBox(
                height: 10.0,
              ),
              // _replyBtnBuilder(),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Divider(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userDetailBuilder() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        widget.review.photoUrl != null
            ? Container(
                width: 55.0,
                height: 55.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(widget.review.photoUrl),
                      fit: BoxFit.cover),
                  shape: BoxShape.circle,
                ),
              )
            : Container(
                width: 55.0,
                height: 55.0,
                child: SvgPicture.asset('assets/svgs/upload_img.svg'),
              ),
        SizedBox(
          width: 5.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '${widget.review.name}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
            ),
            Text(
              'Last updated: ${timeago.format(DateTime.fromMillisecondsSinceEpoch(widget.review.milliseconds))}',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12.0,
                color: Colors.black26,
              ),
            ),
            Row(
              children: <Widget>[
                Text(
                  '(${widget.review.stars})',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12.0,
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                StarRatings(
                  ratings: widget.review.stars,
                  size: 14.0,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _reviewTextBuilder() {
    return Text(
      '${widget.review.reviewText}',
      style: TextStyle(
        color: Colors.black26,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _replyBtnBuilder() {
    return !_isReplying
        ? Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isReplying = true;
                    _focusNode.requestFocus();
                  });
                },
                child: Row(
                  children: <Widget>[
                    Text(
                      'Reply',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12.0,
                        color: Color(0xff45ad90),
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Color(0xff45ad90),
                      size: 14.0,
                    ),
                  ],
                ),
              ),
            ],
          )
        : Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 14.0,
                      ),
                      minLines: 1,
                      maxLines: 4,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Reply here...',
                        suffixIcon: IconButton(
                          icon: Icon(Icons.send),
                          color: Color(0xff45ad90),
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
