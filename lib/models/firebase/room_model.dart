class Room {
  final String id;
  final String name;
  final String dp;
  final double price;

  Room({this.id, this.name, this.dp, this.price});

  static Room fromJson(final Map<String, dynamic> data, final id) {
    return Room(
      id: id ?? '',
      name: data['name'] ?? '',
      dp: data['dp'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
    );
  }
}
