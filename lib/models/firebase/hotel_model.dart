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
  final int rooms;
  final int persons;
  final HotelType type;
  final int commission;
  final int availableCheckIn;
  final int availableCheckOut;

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
    this.availableCheckIn,
    this.availableCheckOut,
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
        price: (data['price'] ?? 0.0).toDouble(),
        summary: data['summary'] ?? '',
        photos: data['photos'] ?? [],
        reviews: data['reviews'] ?? [],
        rooms: data['rooms'] ?? 1,
        persons: data['persons'] ?? 0,
        type: HotelType.hotel,
        commission: data['commission'] ?? 0,
        availableCheckIn: data['available_check_in'],
        availableCheckOut: data['available_check_out'],
      );
    } else if (data['type'] == 1) {
      return Hotel(
        id: id ?? '',
        name: data['name'] ?? '',
        dp: data['dp'],
        city: data['city'] ?? '',
        country: data['country'] ?? '',
        stars: (data['stars'] ?? 3.0).toDouble(),
        price: (data['price'] ?? 0.0).toDouble(),
        summary: data['summary'] ?? '',
        photos: data['photos'] ?? [],
        reviews: data['reviews'] ?? [],
        rooms: data['rooms'] ?? 1,
        persons: data['persons'] ?? 0,
        type: HotelType.backpack,
        commission: data['commission'] ?? 0,
        availableCheckIn: data['available_check_in'],
        availableCheckOut: data['available_check_out'],
      );
    } else if (data['type'] == 2) {
      return Hotel(
        id: id ?? '',
        name: data['name'] ?? '',
        dp: data['dp'],
        city: data['city'] ?? '',
        country: data['country'] ?? '',
        stars: (data['stars'] ?? 3.0).toDouble(),
        price: (data['price'] ?? 0.0).toDouble(),
        summary: data['summary'] ?? '',
        photos: data['photos'] ?? [],
        reviews: data['reviews'] ?? [],
        rooms: data['rooms'] ?? 1,
        persons: data['persons'] ?? 0,
        type: HotelType.resorts,
        commission: data['commission'] ?? 0,
        availableCheckIn: data['available_check_in'],
        availableCheckOut: data['available_check_out'],
      );
    } else if (data['type'] == 3) {
      return Hotel(
        id: id ?? '',
        name: data['name'] ?? '',
        dp: data['dp'],
        city: data['city'] ?? '',
        country: data['country'] ?? '',
        stars: (data['stars'] ?? 3.0).toDouble(),
        price: (data['price'] ?? 0.0).toDouble(),
        summary: data['summary'] ?? '',
        photos: data['photos'] ?? [],
        reviews: data['reviews'] ?? [],
        rooms: data['rooms'] ?? 1,
        persons: data['persons'] ?? 0,
        type: HotelType.villa,
        commission: data['commission'] ?? 0,
        availableCheckIn: data['available_check_in'],
        availableCheckOut: data['available_check_out'],
      );
    }
    return Hotel(
      id: id ?? '',
      name: data['name'] ?? '',
      dp: data['dp'],
      city: data['city'] ?? '',
      country: data['country'] ?? '',
      stars: (data['stars'] ?? 3.0).toDouble(),
      price: (data['price'] ?? 0.0).toDouble(),
      summary: data['summary'] ?? '',
      photos: data['photos'] ?? [],
      reviews: data['reviews'] ?? [],
      rooms: data['rooms'] ?? 1,
      persons: data['persons'] ?? 0,
      type: HotelType.hotel,
      commission: data['commission'] ?? 0,
      availableCheckIn: data['available_check_in'],
      availableCheckOut: data['available_check_out'],
    );
  }
}
