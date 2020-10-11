import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motel/models/firebase/tour_model.dart';
import 'package:motel/models/firebase/user_model.dart';

class TourProvider {
  final Tour tour;
  final AppUser appUser;
  TourProvider({this.tour, this.appUser});

  final _ref = Firestore.instance;

  // publish tour
  Future publishTour() async {
    try {
      final _tourRef = _ref.collection('tours').document();
      tour.id = _tourRef.documentID;
      await _tourRef.setData(tour.toJson());
      print('Success: Publishing tour ${tour.id}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Publishing tour ${tour.id}');
      return null;
    }
  }
}
