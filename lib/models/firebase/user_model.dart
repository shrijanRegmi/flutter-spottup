import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motel/enums/account_type.dart';
import 'package:motel/enums/analytics_status.dart';
import 'package:motel/models/firebase/invitation_from_model.dart';

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
  final String dynamicLink;
  final AnalyticStatus analyticStatus;
  final InvitationFrom invitationFrom;
  final int earnings;

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
    this.dynamicLink,
    this.analyticStatus,
    this.invitationFrom,
    this.earnings,
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
      dynamicLink: data['dynamic_link'],
      analyticStatus: AnalyticStatus.values[data['analytic_status'] ?? 0],
      invitationFrom: data['invitation_from'] == null
          ? null
          : InvitationFrom.fromJson(data['invitation_from']),
      earnings: data['earnings'] ?? 0,
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
