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
  final bool admin;
  final int notifCount;

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
    this.admin,
    this.notifCount,
  });

  static AppUser fromJson(final Map<String, dynamic> data) {
    return AppUser(
      uid: data['uid'] ?? '',
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      email: data['email'] ?? '',
      photoUrl: data['photo_url'] != '' ? data['photo_url'] : null,
      phone: data['phone'] ?? 0,
      dob: data['dob'] ?? 0,
      address: data['address'] ?? 'N/A',
      upcoming: data['upcoming'] ?? [],
      finished: data['finished'] ?? [],
      favourite: data['favourite'] ?? [],
      accountType: AccountType.values[data['account_type'] ?? 0],
      admin: data['admin'] ?? false,
      notifCount: data['notif_count'] ?? 0,
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
      'photo_url': photoUrl ?? '',
    };
  }

  DocumentReference toRef() {
    final _ref = FirebaseFirestore.instance;
    return _ref.collection('users').doc(uid);
  }
}
