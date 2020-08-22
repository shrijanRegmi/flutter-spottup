import 'package:cloud_firestore/cloud_firestore.dart';

class LastSearch {
  final DocumentReference hotelRef;
  final int lastUpdated;

  LastSearch({this.hotelRef, this.lastUpdated});

  Map<String, dynamic> toJson() {
    return {
      'hotel_ref' : hotelRef,
      'last_updated' :lastUpdated,
    };
  }

  static LastSearch fromJson(Map<String, dynamic> data) {
    return LastSearch(
      hotelRef : data['hotel_ref'],
      lastUpdated: data['last_updated'],
    );
  }

}
