import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:motel/models/firebase/user_model.dart';

class UserProvider {
  final String uid;
  UserProvider({this.uid});

  final _ref = Firestore.instance;

  // send user to firestore
  Future sendUserToFirestore(AppUser appUser, String uid) async {
    try {
      final _userRef = _ref.collection('users').document(uid);

      print('Success: Sending user data to firestore');
      return await _userRef.setData(appUser.toJson());
    } catch (e) {
      print(e);
      print('Error!!!: Sending user data to firestore');
      return null;
    }
  }

  // user from firebase
  AppUser _appUserFromFirebase(DocumentSnapshot userSnap) {
    return AppUser.fromJson(userSnap.data);
  }

  // stream of user
  Stream<AppUser> get appUser {
    return _ref
        .collection('users')
        .document(uid)
        .snapshots()
        .map(_appUserFromFirebase);
  }
}
