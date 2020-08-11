class AppUser {
  final String firstName;
  final String lastName;
  final String uid;
  final String email;
  final String photoUrl;
  final int phone;
  final int dob;
  final String address;
  final List<String> upcoming;
  final List<String> finished;
  final List<String> favourite;

  AppUser({
    this.uid,
    this.firstName,
    this.lastName,
    this.email,
    this.photoUrl,
    this.phone,
    this.dob,
    this.address,
    this.upcoming,
    this.finished,
    this.favourite,
  });

  static AppUser fromJson(final Map<String, dynamic> data) {
    return AppUser(
      uid: data['uid'] ?? '',
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photo_url'],
      phone: data['phone'],
      dob: data['dob'],
      address: data['address'] ?? 'N/A',
      upcoming: data['upcoming'],
      finished: data['finished'],
      favourite: data['favourite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'first_name': firstName,
      'last_name' : lastName,
      'email' : email,
      'photo_url' : photoUrl,
      'phone' : phone,
    };
  }
}