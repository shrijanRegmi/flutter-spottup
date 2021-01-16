import 'package:cloud_firestore/cloud_firestore.dart';

class Tour {
  String id;
  final String name;
  final int days;
  final int nights;
  final int price;
  final int person;
  final int start;
  final int end;
  final List<String> photos;
  final String summary;
  final String inclusions;
  final String exclusions;
  final String ownerId;
  final String dp;
  final int updatedAt;
  final String searchKey;
  final String paymentAndCancellationPolicy;
  final int pickUpDate;
  final String pickUpTime;

  Tour({
    this.id,
    this.name,
    this.days,
    this.nights,
    this.price,
    this.person,
    this.start,
    this.end,
    this.photos,
    this.summary,
    this.inclusions,
    this.exclusions,
    this.ownerId,
    this.dp,
    this.updatedAt,
    this.searchKey,
    this.paymentAndCancellationPolicy,
    this.pickUpDate,
    this.pickUpTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'days': days,
      'nights': nights,
      'price': price,
      'person': person,
      'start': start,
      'end': end,
      'photos': photos,
      'summary': summary,
      'inclusions': inclusions,
      'exclusions': exclusions,
      'owner_id': ownerId,
      'dp': dp,
      'updated_at': updatedAt,
      'search_key': name.substring(0, 1),
      'payment_policy': paymentAndCancellationPolicy,
      'pick_up_date': pickUpDate,
      'pick_up_time': pickUpTime,
    };
  }

  static Tour fromJson(final Map<String, dynamic> data) {
    return Tour(
      id: data['id'],
      name: data['name'] ?? '',
      days: data['days'] ?? 0,
      nights: data['nights'] ?? 0,
      price: data['price'] ?? 0,
      person: data['person'] ?? 0,
      start: data['start'] ?? DateTime.now().millisecondsSinceEpoch,
      end: data['end'] ?? DateTime.now().millisecondsSinceEpoch,
      photos: List<String>.from(data['photos'] ?? []),
      summary: data['summary'] ?? '',
      inclusions: data['inclusions'] ?? '',
      exclusions: data['exclusions'] ?? '',
      ownerId: data['owner_id'],
      dp: data['dp'],
      updatedAt: data['updated_at'] ?? DateTime.now().millisecondsSinceEpoch,
      searchKey: data['search_key'] ?? '',
      paymentAndCancellationPolicy: data['payment_policy'] ?? '',
      pickUpDate: data['pick_up_date'],
      pickUpTime: data['pick_up_time'],
    );
  }

  DocumentReference toRef() {
    final _ref = FirebaseFirestore.instance;
    return _ref.collection('tours').doc(id);
  }
}
