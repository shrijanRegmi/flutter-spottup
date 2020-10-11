class Vehicle {
  String id;
  final String name;
  final int modelYear;
  final int seats;
  final int price;
  final List<String> photos;
  final String ownerId;
  final String dp;

  Vehicle({
    this.id,
    this.name,
    this.modelYear,
    this.seats,
    this.price,
    this.photos,
    this.ownerId,
    this.dp,
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
    );
  }
}
