import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motel/enums/account_type.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/user_provider.dart';

class AuthProvider {
  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _ref = Firestore.instance;

  // create account with email and password
  Future signUpWithEmailAndPassword({
    final AppUser appUser,
    final String password,
  }) async {
    try {
      final _result = await _auth.createUserWithEmailAndPassword(
          email: appUser.email, password: password);

      appUser.uid = _result.user.uid;

      await UserProvider().sendUserToFirestore(appUser, _result.user.uid);

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
    final bool isOwner,
  }) async {
    try {
      final _result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      final _userRef = _ref.collection('users').document(_result.user.uid);

      await _userRef.updateData({
        'account_type':
            isOwner ? AccountType.hotelOwner.index : AccountType.general.index
      });

      _userFromFirebase(_result.user);
      print('Success: Logging in user with email $email');
      return _result;
    } catch (e) {
      print(e);
      print('Error!!!: Logging in user with email $email');
      return null;
    }
  }

  // sign up with google
  Future signUpWithGoogle({
    final bool isOwner,
  }) async {
    try {
      final _account = await _googleSignIn.signIn();
      final _tokens = await _account.authentication;
      final _cred = GoogleAuthProvider.getCredential(
          idToken: _tokens.idToken, accessToken: _tokens.accessToken);
      final _result = await _auth.signInWithCredential(_cred);

      final _user = _result.user;

      final _appUser = AppUser(
        firstName: _user.displayName.split(' ')[0],
        lastName: _user.displayName.split(' ')[1],
        email: _user.email,
        uid: _result.user.uid,
        accountType: isOwner ? AccountType.hotelOwner : AccountType.general,
      );

      final _ref = Firestore.instance;

      final _userRef = _ref.collection('users').document(_user.uid);

      final _userSnap = await _userRef.get();

      if (_userSnap.data == null) {
        await UserProvider().sendUserToFirestore(_appUser, _result.user.uid);
        _userFromFirebase(_user);
        print('Success: Signing up user with name ${_user.displayName}');
      } else {
        await _userRef.updateData({
          'account_type': isOwner
              ? AccountType.hotelOwner.index
              : AccountType.general.index,
        });
        _userFromFirebase(_user);
        print('Success: Logging in user with name ${_user.displayName}');
      }
      return _user;
    } catch (e) {
      print(e);
      print('Error!!!: Signing up with google');
      return null;
    }
  }

  // log out user
  Future logOut() async {
    print('Success: Logging out user');
    await _googleSignIn?.signOut();
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
