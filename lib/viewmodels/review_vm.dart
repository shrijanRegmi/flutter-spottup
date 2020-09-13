import 'package:flutter/material.dart';
import 'package:motel/models/firebase/review_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/review_provider.dart';

class ReviewVm extends ChangeNotifier {
  final BuildContext context;
  ReviewVm(this.context);
  
  TextEditingController _reviewController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  double _stars = 0.0;
  bool _isLoading = false;

  TextEditingController get reviewController => _reviewController;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  double get stars => _stars;
  bool get isLoading => _isLoading;

  // publish the review
  submitReview(final AppUser appUser, final String hotelId) async {
    if (_reviewController.text.trim() != '') {
      _updateLoadingValue(true);
      final _review = Review(
        id: appUser.uid,
        name: '${appUser.firstName} ${appUser.lastName}',
        stars: _stars,
        reviewText: _reviewController.text.trim(),
        milliseconds: DateTime.now().millisecondsSinceEpoch,
        photoUrl: appUser.photoUrl,
      );

      final _result = await ReviewProvider(hotelId: hotelId, uid: appUser.uid)
          .publishReview(_review);

      if (_result == null) {
        _updateLoadingValue(false);
      } else {
        Navigator.pop(context);
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text('Your review is important. Please provide your review.'),
      ));
    }
  }

  // update value of loading
  _updateLoadingValue(final bool newVal) {
    _isLoading = newVal;
    notifyListeners();
  }

  // on drag on stars
  updateStars(final double newVal) {
    _stars = newVal;
    notifyListeners();
  }
}
