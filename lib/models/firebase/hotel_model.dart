import 'package:motel/enums/hotel_types.dart';

class Hotel {
  final String id;
  final String name;
  final String dp;
  final String city;
  final String country;
  final double stars;
  final double price;
  final String summary;
  final List<dynamic> photos;
  final List<dynamic> reviews;
  final List<dynamic> rooms;
  final int persons;
  final HotelType type;
  final int commission;

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
    this.commission,
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
        price: data['price'].toDouble().toDouble() ?? 0.0,
        summary: data['summary'] ?? '',
        photos: data['photos'] ?? [],
        reviews: data['reviews'] ?? [],
        rooms: data['rooms'] ?? [],
        persons: data['persons'] ?? 0,
        type: HotelType.hotel,
        commission: data['commission'] ?? 0,
      );
    } else if (data['type'] == 1) {
      return Hotel(
        id: id ?? '',
        name: data['name'] ?? '',
        dp: data['dp'],
        city: data['city'] ?? '',
        country: data['country'] ?? '',
        stars: data['stars'] ?? 3.0,
        price: (data['price'] ?? 0.0).toDouble(),
        summary: data['summary'] ?? '',
        photos: data['photos'] ?? [],
        reviews: data['reviews'] ?? [],
        rooms: data['rooms'] ?? [],
        persons: data['persons'] ?? 0,
        type: HotelType.backpack,
        commission: data['commission'] ?? 0,
      );
    } else if (data['type'] == 2) {
      return Hotel(
        id: id ?? '',
        name: data['name'] ?? '',
        dp: data['dp'],
        city: data['city'] ?? '',
        country: data['country'] ?? '',
        stars: data['stars'] ?? 3.0,
        price: (data['price'] ?? 0.0).toDouble(),
        summary: data['summary'] ?? '',
        photos: data['photos'] ?? [],
        reviews: data['reviews'] ?? [],
        rooms: data['rooms'] ?? [],
        persons: data['persons'] ?? 0,
        type: HotelType.resorts,
        commission: data['commission'] ?? 0,
      );
    } else if (data['type'] == 3) {
      return Hotel(
        id: id ?? '',
        name: data['name'] ?? '',
        dp: data['dp'],
        city: data['city'] ?? '',
        country: data['country'] ?? '',
        stars: data['stars'] ?? 3.0,
        price: (data['price'] ?? 0.0).toDouble(),
        summary: data['summary'] ?? '',
        photos: data['photos'] ?? [],
        reviews: data['reviews'] ?? [],
        rooms: data['rooms'] ?? [],
        persons: data['persons'] ?? 0,
        type: HotelType.villa,
        commission: data['commission'] ?? 0,
      );
    }
    return Hotel(
      id: id ?? '',
      name: data['name'] ?? '',
      dp: data['dp'],
      city: data['city'] ?? '',
      country: data['country'] ?? '',
      stars: data['stars'] ?? 3.0,
      price: (data['price'] ?? 0.0).toDouble(),
      summary: data['summary'] ?? '',
      photos: data['photos'] ?? [],
      reviews: data['reviews'] ?? [],
      rooms: data['rooms'] ?? [],
      persons: data['persons'] ?? 0,
      type: HotelType.hotel,
      commission: data['commission'] ?? 0,
    );
  }
}
