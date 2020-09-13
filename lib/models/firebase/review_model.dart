class Review {
  final String id;
  final String name;
  final int milliseconds;
  final double stars;
  final String reviewText;
  final String photoUrl;
  Review({
    this.id,
    this.name,
    this.milliseconds,
    this.stars,
    this.reviewText,
    this.photoUrl,
  });

  static Review fromJson(final Map<String, dynamic> data) {
    return Review(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      milliseconds:
          data['milliseconds'] ?? DateTime.now().millisecondsSinceEpoch,
      stars: data['stars'] ?? 3.0,
      reviewText: data['review_text'] ?? '',
      photoUrl: data['photo_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'milliseconds': milliseconds,
      'stars': stars,
      'review_text': reviewText,
      'photo_url': photoUrl,
    };
  }
}
