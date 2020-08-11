class Review {
  final String id;
  final String name;
  final int milliseconds;
  final double stars;
  final String reviewText;
  final List<String> replies;
  Review({
    this.id,
    this.name,
    this.milliseconds,
    this.stars,
    this.reviewText,
    this.replies,
  });

  static Review fromJson(final Map<String, dynamic> data) {
    return Review(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      milliseconds: data['milliseconds'] ?? 0,
      stars: data['stars'] ?? 3.0,
      reviewText: data['review_text'] ?? '',
      replies: data['replies'] ?? [],
    );
  }
}
