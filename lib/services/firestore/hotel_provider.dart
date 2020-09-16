import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
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
      final _hotelRef = _ref.collection('hotels').document();
      hotel.id = _hotelRef.documentID;
      print('Success: Adding new hotel');
      return await _hotelRef.setData(hotel.toJson());
    } catch (e) {
      print(e);
      print('Error!!!: Adding new hotel');
      return null;
    }
  }

  // upload all rooms
  Future uploadNewRoom(
      final DocumentReference _hotelRef, final Hotel _room) async {
    try {
      final _roomRef = _hotelRef.collection('rooms').document();
      _room.id = _roomRef.documentID;
      print('Success: Uploading new room');
      return await _roomRef.setData(_room.toJson());
    } catch (e) {
      print(e);
      print('Error!!!: Uploading new room');
      return null;
    }
  }

  // delele hotel
  Future deleteHotel(final String _hotelId) async {
    try {
      final _hotelRef = _ref.collection('hotels').document(_hotelId);
      await _hotelRef.delete();
      print('Success: Deleting hotel with id $_hotelId');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Deleting hotel with id $_hotelId');
      return null;
    }
  }

  // update booking data
  Future updateBookingData(final Map<String, dynamic> data, final String id) {
    try {
      final _bookingRef = _ref.collection('bookings').document(id);
      print('Success: Updating hotel data $data');
      return _bookingRef.updateData(data);
    } catch (e) {
      print(e);
      print('Error!!!: Updating hotel data $data');
      return null;
    }
  }

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

  // hotel from firebase
  Hotel _hotelFromFirebase(DocumentSnapshot docSnap) {
    return Hotel.fromJson(docSnap.data);
  }

  // room from firebase
  List<Hotel> _roomFromFirebase(QuerySnapshot colSnap) {
    return colSnap.documents.map((docSnap) {
      return Hotel.fromJson(docSnap.data);
    }).toList();
  }

  // last searches collection from firebase
  List<LastSearch> _lastSearchFromFirebase(QuerySnapshot colSnap) {
    return colSnap.documents.map((docSnap) {
      return LastSearch.fromJson(docSnap.data);
    }).toList();
  }

  // bookings from firebase
  List<ConfirmBooking> _bookingFromFirebase(QuerySnapshot colSnap) {
    return colSnap.documents
        .map((doc) => ConfirmBooking.fromJson(doc.data))
        .toList();
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
        .orderBy('updated_at', descending: true)
        .snapshots()
        .map(_hotelsFromFirestore);
  }

  // stream of bookings
  Stream<List<ConfirmBooking>> get bookingsList {
    return _ref
        .collection('bookings')
        .where('owner_id', isEqualTo: uid)
        .orderBy('issue_date', descending: true)
        .snapshots()
        .map(_bookingFromFirebase);
  }
}
