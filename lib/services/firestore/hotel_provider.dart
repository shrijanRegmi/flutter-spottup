import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/popular_destination_model.dart';
import 'package:motel/models/firebase/top_three_model.dart';

class HotelProvider {
  final _ref = Firestore.instance;
  // hotels list from firestore
  List<Hotel> _hotelsFromFirestore(QuerySnapshot colSnap) {
    return colSnap.documents.map((docSnap) {
      return Hotel.fromJson(docSnap.data);
    }).toList();
  }

  // top three list from firestore
  List<TopThree> _topThreeFromFirestore(QuerySnapshot colSnap) {
    return colSnap.documents.map((docSnap) {
      return TopThree.fromJson(docSnap.data);
    }).toList();
  }

  // popular destinations list from firestore
  List<PopularDestination> _popularDestinationsFromFirestore(
      QuerySnapshot colSnap) {
    return colSnap.documents.map((docSnap) {
      return PopularDestination.fromJson(docSnap.data);
    }).toList();
  }

  // stream of hotels list
  Stream<List<Hotel>> get hotelsList {
    return _ref.collection('hotels').snapshots().map(_hotelsFromFirestore);
  }

  // stream of top three
  Stream<List<TopThree>> get topThree {
    return _ref.collection('top_three').snapshots().map(_topThreeFromFirestore);
  }

  // stream of popular destinations
  Stream<List<PopularDestination>> get popularDestinations {
    return _ref
        .collection('popular_destinations')
        .snapshots()
        .map(_popularDestinationsFromFirestore);
  }
}
