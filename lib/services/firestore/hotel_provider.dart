import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/popular_destination_model.dart';
import 'package:motel/models/firebase/room_model.dart';
import 'package:motel/models/firebase/top_three_model.dart';

class HotelProvider {
  final String hotelId;
  final int limit;
  final String city;
  HotelProvider({this.hotelId, this.limit = 5, this.city});

  final _ref = Firestore.instance;
  // hotels list from firestore
  List<Hotel> _hotelsFromFirestore(QuerySnapshot colSnap) {
    return colSnap.documents.map((docSnap) {
      return Hotel.fromJson(docSnap.data, docSnap.documentID);
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

  // hotel from firebase
  Hotel _hotelFromFirebase(DocumentSnapshot docSnap) {
    return Hotel.fromJson(docSnap.data, docSnap.documentID);
  }

  // room from firebase
  List<Room> _roomFromFirebase(QuerySnapshot colSnap) {
    return colSnap.documents.map((docSnap) {
      return Room.fromJson(docSnap.data, docSnap.documentID);
    }).toList();
  }

  // stream of hotels list
  Stream<List<Hotel>> get hotelsList {
    return _ref.collection('hotels').snapshots().map(_hotelsFromFirestore);
  }

  // stream of all best deals list
  Stream<List<Hotel>> get allBestDeals {
    return _ref
        .collection('hotels')
        .where('is_best_deal', isEqualTo: true)
        .snapshots()
        .map(_hotelsFromFirestore);
  }

  // stream of limited best deals list
  Stream<List<Hotel>> get limitedBestDeals {
    return _ref
        .collection('hotels')
        .limit(limit)
        .where('is_best_deal', isEqualTo: true)
        .snapshots()
        .map(_hotelsFromFirestore);
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

  // stream of favourite hotels
  Stream<Hotel> get hotelFromId {
    return _ref
        .collection('hotels')
        .document(hotelId)
        .snapshots()
        .map(_hotelFromFirebase);
  }

  // stream of rooms
  Stream<List<Room>> get roomsList {
    return _ref
        .collection('hotels')
        .document(hotelId)
        .collection('rooms')
        .orderBy('price')
        .snapshots()
        .map(_roomFromFirebase);
  }

  // stream of searched hotel
  Stream<List<Hotel>> get searchedHotels {
    return _ref
        .collection('hotels')
        .limit(50)
        .where('city', isEqualTo: city)
        .snapshots()
        .map(_hotelsFromFirestore);
  }
}
