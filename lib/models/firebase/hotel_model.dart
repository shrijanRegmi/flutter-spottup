import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motel/enums/hotel_types.dart';

class Hotel {
  final String id;
  final String name;
  final String dp;
  final String city;
  final String country;
  final double stars;
  final int price;
  final String summary;
  final List<dynamic> photos;
  final List<dynamic> reviews;
  final int rooms;
  final int adults;
  final int kids;
  final HotelType type;
  final int commission;
  final int availableCheckIn;
  final int availableCheckOut;
  final String ownerId;

  Hotel({
    this.id,
    this.name,
    this.dp,
    this.city,
    this.country,
    this.stars,
    this.price,
    this.summary,
    this.photos,
    this.reviews,
    this.rooms,
    this.adults,
    this.kids,
    this.type,
    this.commission,
    this.availableCheckIn,
    this.availableCheckOut,
    this.ownerId,
  });

  static Hotel fromJson(final Map<String, dynamic> data, final String id) {
    if (data['type'] == 0) {
      return Hotel(
        id: id ?? '',
        name: data['name'] ?? '',
        dp: data['dp'],
        city: data['city'] ?? '',
        country: data['country'] ?? '',
        stars: (data['stars'] ?? 3.0).toDouble(),
        price: data['price'] ?? 0,
        summary: data['summary'] ?? '',
        photos: data['photos'] ?? [],
        reviews: data['reviews'] ?? [],
        rooms: data['rooms'] ?? 1,
        adults: data['adults'] ?? 0,
        kids: data['kids'] ?? 0,
        type: HotelType.hotel,
        commission: data['commission'] ?? 0,
        availableCheckIn: data['available_check_in'],
        availableCheckOut: data['available_check_out'],
        ownerId: data['owner_id'] ?? '',
      );
    } else if (data['type'] == 1) {
      return Hotel(
        id: id ?? '',
        name: data['name'] ?? '',
        dp: data['dp'],
        city: data['city'] ?? '',
        country: data['country'] ?? '',
        stars: (data['stars'] ?? 3.0).toDouble(),
        price: data['price'] ?? 0,
        summary: data['summary'] ?? '',
        photos: data['photos'] ?? [],
        reviews: data['reviews'] ?? [],
        rooms: data['rooms'] ?? 1,
        adults: data['adults'] ?? 0,
        kids: data['kids'] ?? 0,
        type: HotelType.backpack,
        commission: data['commission'] ?? 0,
        availableCheckIn: data['available_check_in'],
        availableCheckOut: data['available_check_out'],
        ownerId: data['owner_id'] ?? '',
      );
    } else if (data['type'] == 2) {
      return Hotel(
        id: id ?? '',
        name: data['name'] ?? '',
        dp: data['dp'],
        city: data['city'] ?? '',
        country: data['country'] ?? '',
        stars: (data['stars'] ?? 3.0).toDouble(),
        price: data['price'] ?? 0,
        summary: data['summary'] ?? '',
        photos: data['photos'] ?? [],
        reviews: data['reviews'] ?? [],
        rooms: data['rooms'] ?? 1,
        adults: data['adults'] ?? 0,
        kids: data['kids'] ?? 0,
        type: HotelType.resorts,
        commission: data['commission'] ?? 0,
        availableCheckIn: data['available_check_in'],
        availableCheckOut: data['available_check_out'],
        ownerId: data['owner_id'] ?? '',
      );
    } else if (data['type'] == 3) {
      return Hotel(
        id: id ?? '',
        name: data['name'] ?? '',
        dp: data['dp'],
        city: data['city'] ?? '',
        country: data['country'] ?? '',
        stars: (data['stars'] ?? 3.0).toDouble(),
        price: data['price'] ?? 0,
        summary: data['summary'] ?? '',
        photos: data['photos'] ?? [],
        reviews: data['reviews'] ?? [],
        rooms: data['rooms'] ?? 1,
        adults: data['adults'] ?? 0,
        kids: data['kids'] ?? 0,
        type: HotelType.villa,
        commission: data['commission'] ?? 0,
        availableCheckIn: data['available_check_in'],
        availableCheckOut: data['available_check_out'],
        ownerId: data['owner_id'] ?? '',
      );
    }
    return Hotel(
      id: id ?? '',
      name: data['name'] ?? '',
      dp: data['dp'],
      city: data['city'] ?? '',
      country: data['country'] ?? '',
      stars: (data['stars'] ?? 3.0).toDouble(),
      price: data['price'] ?? 0,
      summary: data['summary'] ?? '',
      photos: data['photos'] ?? [],
      reviews: data['reviews'] ?? [],
      rooms: data['rooms'] ?? 1,
      adults: data['adults'] ?? 0,
      kids: data['kids'] ?? 0,
      type: HotelType.hotel,
      commission: data['commission'] ?? 0,
      availableCheckIn: data['available_check_in'],
      availableCheckOut: data['available_check_out'],
      ownerId: data['owner_id'] ?? '',
    );
  }

  DocumentReference toRef() {
    final _ref = Firestore.instance;
    return _ref.collection('hotels').document(id);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'dp': dp,
      'city': city,
      'country': country,
      'price': price,
      'summary': summary,
      'photos': photos,
      'owner_id': ownerId,
      'kids': kids,
      'adults': adults,
    };
  }
}
