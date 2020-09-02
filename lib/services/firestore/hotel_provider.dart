import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motel/models/firebase/hotel_model.dart';
import 'package:motel/models/firebase/popular_destination_model.dart';
import 'package:motel/models/firebase/last_search_model.dart';
import 'package:motel/models/firebase/top_three_model.dart';

class HotelProvider {
  final String hotelId;
  final int limit;
  final String city;
  final String searchKey;
  final String uid;
  final DocumentReference hotelRef;
  HotelProvider(
      {this.hotelId,
      this.limit = 5,
      this.city,
      this.searchKey,
      this.uid,
      this.hotelRef});

  final _ref = Firestore.instance;

  // upload new hotel by hotel owner
  Future uploadNewHotel(Hotel hotel) async {
    try {
      final _hotelRef = _ref.collection('hotels');
      print('Success: Adding new hotel');
      return await _hotelRef.add(hotel.toJson());
    } catch (e) {
      print(e);
      print('Error!!!: Adding new hotel');
      return null;
    }
  }

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
  List<Hotel> _roomFromFirebase(QuerySnapshot colSnap) {
    return colSnap.documents.map((docSnap) {
      return Hotel.fromJson(docSnap.data, docSnap.documentID);
    }).toList();
  }

  List<LastSearch> _lastSearchFromFirebase(QuerySnapshot colSnap) {
    return colSnap.documents.map((docSnap) {
      return LastSearch.fromJson(docSnap.data);
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

  // stream of hotel from document reference
  Stream<Hotel> get hotelFromRef {
    return hotelRef.snapshots().map(_hotelFromFirebase);
  }

  // stream of rooms
  Stream<List<Hotel>> get roomsList {
    return _ref
        .collection('hotels')
        .document(hotelId)
        .collection('rooms')
        .orderBy('price')
        .snapshots()
        .map(_roomFromFirebase);
  }

  // stream of searched hotel
  Stream<List<Hotel>> get searchedHotelsFromCity {
    return _ref
        .collection('hotels')
        .limit(50)
        .where('city', isEqualTo: city)
        .snapshots()
        .map(_hotelsFromFirestore);
  }

  // stream of hotel from search key
  Stream<List<Hotel>> get searchedHotelsFromKey {
    return _ref
        .collection('hotels')
        .limit(50)
        .where('search_key', isEqualTo: searchKey)
        .snapshots()
        .map(_hotelsFromFirestore);
  }

  // stream of hotel that user last searched
  Stream<List<LastSearch>> get lastSearchList {
    return _ref
        .collection('users')
        .document(uid)
        .collection('last_search')
        .limit(5)
        .orderBy('last_updated', descending: true)
        .snapshots()
        .map(_lastSearchFromFirebase);
  }

  // stream of hotels owned by owner
  Stream<List<Hotel>> get myHotels {
    return _ref
        .collection('hotels')
        .limit(50)
        .where('owner_id', isEqualTo: uid)
        .snapshots()
        .map(_hotelsFromFirestore);
  }
}
