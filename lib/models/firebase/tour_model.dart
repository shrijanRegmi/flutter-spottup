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
    );
  }
}
