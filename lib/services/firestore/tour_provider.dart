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

  // tours list from firestore
  List<Tour> _toursFromFirestore(QuerySnapshot colSnap) {
    return colSnap.documents.map((docSnap) {
      return Tour.fromJson(docSnap.data);
    }).toList();
  }

  // stream of tours owned by owner
  Stream<List<Tour>> get myTours {
    return _ref
        .collection('hotels')
        .limit(50)
        .where('owner_id', isEqualTo: appUser.uid)
        .orderBy('updated_at', descending: true)
        .snapshots()
        .map(_toursFromFirestore);
  }
}
