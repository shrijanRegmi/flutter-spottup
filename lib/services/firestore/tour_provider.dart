import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motel/models/firebase/tour_model.dart';
import 'package:motel/models/firebase/user_model.dart';

class TourProvider {
  final Tour tour;
  final AppUser appUser;
  final String searchKey;
  TourProvider({
    this.tour,
    this.appUser,
    this.searchKey,
  });

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

  // update tour
  Future updateTour() async {
    try {
      final _tourRef = tour.toRef();
      await _tourRef.updateData(tour.toJson());
      print('Success: Updating tour details ${tour.id}');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Updating tour details ${tour.id}');
      return null;
    }
  }

  // delete tour
  Future deleteTour(final String tourId) async {
    try {
      final _tourRef = _ref.collection('tours').document(tourId);
      await _tourRef.delete();
      print('Success: Deleting tour $tourId');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error: Deleting tour $tourId');
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
        .collection('tours')
        .limit(50)
        .where('owner_id', isEqualTo: appUser.uid)
        .orderBy('updated_at', descending: true)
        .snapshots()
        .map(_toursFromFirestore);
  }

  // stream of best tours deals
  Stream<List<Tour>> get limitedBestDeals {
    return _ref
        .collection('tours')
        .limit(5)
        .where('is_best_deal', isEqualTo: true)
        .snapshots()
        .map(_toursFromFirestore);
  }

  // stream of best tours deals
  Stream<List<Tour>> get allBestDeals {
    return _ref
        .collection('tours')
        .where('is_best_deal', isEqualTo: true)
        .snapshots()
        .map(_toursFromFirestore);
  }

  // stream of tours from search key
  Stream<List<Tour>> get searchedToursFromKey {
    return _ref
        .collection('tours')
        .limit(50)
        .where('search_key', isEqualTo: searchKey)
        .snapshots()
        .map(_toursFromFirestore);
  }
}
