class PopularDestination {
  final String name;
  final String dp;

  PopularDestination({this.name, this.dp});

  static PopularDestination fromJson(final Map<String, dynamic> data) {
    return PopularDestination(
      name: data['name'] ?? '',
      dp: data['dp'],
    );
  }
}
