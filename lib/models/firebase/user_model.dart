import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motel/enums/account_type.dart';

class AppUser {
  final String firstName;
  final String lastName;
  String uid;
  final String email;
  final String photoUrl;
  final int phone;
  final int dob;
  final String address;
  final List<dynamic> upcoming;
  final List<dynamic> finished;
  final List<dynamic> favourite;
  final AccountType accountType;

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
    this.accountType,
  });

  static AppUser fromJson(final Map<String, dynamic> data) {
    if (data['account_type'] == AccountType.hotelOwner.index) {
      return AppUser(
        uid: data['uid'] ?? '',
        firstName: data['first_name'] ?? '',
        lastName: data['last_name'] ?? '',
        email: data['email'] ?? '',
        photoUrl: data['photo_url'],
        phone: data['phone'] ?? 0,
        dob: data['dob'] ?? 0,
        address: data['address'] ?? 'N/A',
        upcoming: data['upcoming'] ?? [],
        finished: data['finished'] ?? [],
        favourite: data['favourite'] ?? [],
        accountType: AccountType.hotelOwner,
      );
    } else if (data['account_type'] == AccountType.hotelOwner.index) {
      return AppUser(
        uid: data['uid'] ?? '',
        firstName: data['first_name'] ?? '',
        lastName: data['last_name'] ?? '',
        email: data['email'] ?? '',
        photoUrl: data['photo_url'],
        phone: data['phone'] ?? 0,
        dob: data['dob'] ?? 0,
        address: data['address'] ?? 'N/A',
        upcoming: data['upcoming'] ?? [],
        finished: data['finished'] ?? [],
        favourite: data['favourite'] ?? [],
        accountType: AccountType.admin,
      );
    }
    return AppUser(
      uid: data['uid'] ?? '',
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photo_url'],
      phone: data['phone'] ?? 0,
      dob: data['dob'] ?? 0,
      address: data['address'] ?? 'N/A',
      upcoming: data['upcoming'] ?? [],
      finished: data['finished'] ?? [],
      favourite: data['favourite'] ?? [],
      accountType: AccountType.general,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'account_type': accountType?.index,
    };
  }

  DocumentReference toRef() {
    final _ref = Firestore.instance;
    return _ref.collection('users').document(uid);
  }
}
