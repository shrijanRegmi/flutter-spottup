class TopThree {
  final String name;
  final String details;
  final String dp;

  TopThree({this.name, this.details, this.dp});

  static TopThree fromJson(final Map<String, dynamic> data) {
    return TopThree(
      name: data['name'] ?? '',
      details: data['details'] ?? '',
      dp: data['dp'],
    );
  }
}
