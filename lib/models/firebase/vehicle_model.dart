import 'package:cloud_firestore/cloud_firestore.dart';

class Vehicle {
  String id;
  final String name;
  final int modelYear;
  final int seats;
  final int price;
  final List<String> photos;
  final String ownerId;
  final String dp;
  final String summary;
  final int updatedAt;
  final String searchKey;
  final List<Map<String, dynamic>> whoWillPay;

  Vehicle({
    this.id,
    this.name,
    this.modelYear,
    this.seats,
    this.price,
    this.photos,
    this.ownerId,
    this.dp,
    this.summary,
    this.updatedAt,
    this.searchKey,
    this.whoWillPay,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'model_year': modelYear,
      'seats': seats,
      'price': price,
      'photos': photos,
      'owner_id': ownerId,
      'dp': dp,
      'summary': summary,
      'updated_at': updatedAt,
      'search_key': name.substring(0, 1),
      'who_will_pay': whoWillPay,
    };
  }

  static Vehicle fromJson(final Map<String, dynamic> data) {
    return Vehicle(
      id: data['id'],
      name: data['name'] ?? '',
      modelYear: data['model_year'] ?? 2013,
      seats: data['seats'] ?? 0,
      price: data['price'] ?? 0,
      photos: List<String>.from(data['photos'] ?? []),
      ownerId: data['owner_id'],
      dp: data['dp'],
      summary: data['summary'] ?? '',
      updatedAt: data['updated_at'] ?? DateTime.now().millisecondsSinceEpoch,
      searchKey: data['search_key'] ?? '',
      whoWillPay: List<Map<String, dynamic>>.from(data['who_will_pay'] ?? []),
    );
  }

  DocumentReference toRef() {
    final _ref = FirebaseFirestore.instance;
    return _ref.collection('vehicles').doc(id);
  }
}
