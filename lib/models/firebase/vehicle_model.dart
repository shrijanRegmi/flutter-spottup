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
    );
  }

  DocumentReference toRef() {
    final _ref = Firestore.instance;
    return _ref.collection('vehicles').document(id);
  }
}
