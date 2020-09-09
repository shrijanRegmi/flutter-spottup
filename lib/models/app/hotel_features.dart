class HotelFeatures {
  final String title;
  bool isSelected;
  HotelFeatures({this.title, this.isSelected = false});

  static HotelFeatures fromJson(final Map<String, dynamic> data) {
    return HotelFeatures(
      title: data['title'] ?? '',
      isSelected: data['is_selected'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'is_selected': isSelected,
    };
  }

  static List<HotelFeatures> listFromJson(final featuresData) {
    List<HotelFeatures> _myFeatures = [];
    featuresData.forEach((feature) {
      _myFeatures.add(fromJson(feature));
    });
    return _myFeatures;
  }

  List<Map<String, dynamic>> listToJson(final List<HotelFeatures> features) {
    List<Map<String, dynamic>> _featuresJson = [];
    features.forEach((feature) {
      _featuresJson.add(feature.toJson());
    });
    return _featuresJson;
  }
}

final List<HotelFeatures> featuresList = [
  HotelFeatures(title: 'Parking'),
  HotelFeatures(title: 'Wifi'),
  HotelFeatures(title: 'Hot Water'),
  HotelFeatures(title: 'Generator'),
  HotelFeatures(title: 'Restaurants'),
  HotelFeatures(title: 'Room Service'),
  HotelFeatures(title: 'Disable Access'),
  HotelFeatures(title: 'Laundry Service'),
];
