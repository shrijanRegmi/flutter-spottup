import 'package:firebase_auth/firebase_auth.dart';
import 'package:motel/models/firebase/user_model.dart';

class AuthProvider {
  final _auth = FirebaseAuth.instance;

  // create account with email and password
  Future signUpWithEmailAndPassword({
    final AppUser appUser,
    final String password,
  }) async {
    try {
      final _result = await _auth.createUserWithEmailAndPassword(
          email: appUser.email, password: password);

      // await UserProvider().sendUserToFirestore(appUser, _result.user.uid);

      _userFromFirebase(_result.user);
      print(
          'Success: Creating user with name ${appUser.firstName} ${appUser.lastName}');
      return _result;
    } catch (e) {
      print(e);
      print(
          'Error!!!: Creating user with name ${appUser.firstName} ${appUser.lastName}');
      return null;
    }
  }

  // login with email and password
  Future loginWithEmailAndPassword({
    final String email,
    final String password,
  }) async {
    try {
      final _result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      _userFromFirebase(_result.user);
      print('Success: Logging in user with email $email');
      return _result;
    } catch (e) {
      print(e);
      print('Error!!!: Logging in user with email $email');
      return null;
    }
  }

  // log out user
  Future logOut() async {
    print('Success: Logging out user');
    return await _auth.signOut();
  }

  // user from firebase
  AppUser _userFromFirebase(FirebaseUser user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  // stream of user
  Stream<AppUser> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebase);
  }
}
