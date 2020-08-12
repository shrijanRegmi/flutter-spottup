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
  final List<dynamic> rooms;
  final int persons;
  final HotelType type;

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
    this.persons,
    this.type,
  });

  static Hotel fromJson(final Map<String, dynamic> data, final String id) {
    if (data['type'] == 0) {
      return Hotel(
        id: id ?? '',
        name: data['name'] ?? '',
        dp: data['dp'],
        city: data['city'] ?? '',
        country: data['country'] ?? '',
        stars: data['stars'] ?? 3.0,
        price: data['price'] ?? 0,
        summary: data['summary'] ?? '',
        photos: data['photos'] ?? [],
        reviews: data['reviews'] ?? [],
        rooms: data['rooms'] ?? [],
        persons: data['persons'] ?? 0,
        type: HotelType.hotel,
      );
    } else if (data['type'] == 1) {
      return Hotel(
        id: id ?? '',
        name: data['name'] ?? '',
        dp: data['dp'],
        city: data['city'] ?? '',
        country: data['country'] ?? '',
        stars: data['stars'] ?? 3.0,
        price: data['price'] ?? 0,
        summary: data['summary'] ?? '',
        photos: data['photos'] ?? [],
        reviews: data['reviews'] ?? [],
        rooms: data['rooms'] ?? [],
        persons: data['persons'] ?? 0,
        type: HotelType.backpack,
      );
    } else if (data['type'] == 2) {
      return Hotel(
        id: id ?? '',
        name: data['name'] ?? '',
        dp: data['dp'],
        city: data['city'] ?? '',
        country: data['country'] ?? '',
        stars: data['stars'] ?? 3.0,
        price: data['price'] ?? 0,
        summary: data['summary'] ?? '',
        photos: data['photos'] ?? [],
        reviews: data['reviews'] ?? [],
        rooms: data['rooms'] ?? [],
        persons: data['persons'] ?? 0,
        type: HotelType.resorts,
      );
    } else if (data['type'] == 3) {
      return Hotel(
        id: id ?? '',
        name: data['name'] ?? '',
        dp: data['dp'],
        city: data['city'] ?? '',
        country: data['country'] ?? '',
        stars: data['stars'] ?? 3.0,
        price: data['price'] ?? 0,
        summary: data['summary'] ?? '',
        photos: data['photos'] ?? [],
        reviews: data['reviews'] ?? [],
        rooms: data['rooms'] ?? [],
        persons: data['persons'] ?? 0,
        type: HotelType.villa,
      );
    }
    return Hotel(
      id: id ?? '',
      name: data['name'] ?? '',
      dp: data['dp'],
      city: data['city'] ?? '',
      country: data['country'] ?? '',
      stars: data['stars'] ?? 3.0,
      price: data['price'] ?? 0,
      summary: data['summary'] ?? '',
      photos: data['photos'] ?? [],
      reviews: data['reviews'] ?? [],
      rooms: data['rooms'] ?? [],
      persons: data['persons'] ?? 0,
      type: HotelType.hotel,
    );
  }
}
