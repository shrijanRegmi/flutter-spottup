class RoomPrice {
  final int fromDate;
  final int toDate;
  final String price;
  RoomPrice({
    this.fromDate,
    this.toDate,
    this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'from_date': fromDate,
      'to_date': toDate,
      'price': price,
    };
  }

  static RoomPrice fromJson(final Map<String, dynamic> data) {
    return RoomPrice(
      fromDate: data['from_date'],
      toDate: data['to_date'],
      price: data['price'],
    );
  }
}
