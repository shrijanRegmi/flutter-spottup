import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:motel/enums/account_type.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/user_provider.dart';
import 'package:motel/views/screens/auth/verification_screen.dart';

import '../dynamic_link_provider.dart';

class AuthProvider {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final BuildContext context;
  AuthProvider({
    this.scaffoldKey,
    this.context,
  });

  final _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final _ref = FirebaseFirestore.instance;

  final _phoneCode = '+977';

  // sign in with phone
  Future signUpWithPhone(final String phoneNum, final AppUser appUser) async {
    try {
      var result;

      final _userRef =
          _ref.collection('users').where('phone', isEqualTo: phoneNum).limit(1);
      final _userSnap = await _userRef.get();

      if (_userSnap.docs.isEmpty) {
        await _auth.verifyPhoneNumber(
          phoneNumber: _phoneCode + phoneNum,
          verificationCompleted: (cred) async {
            final _result = await _auth.signInWithCredential(cred);
            final _user = _result.user;

            appUser.uid = _user.uid;
            await UserProvider().sendUserToFirestore(appUser, _result.user.uid);
            await DynamicLinkProvider(_user.uid).handleDynamicLinks();
            _userFromFirebase(_user);
            print('Success: Signing up user with name ${appUser.firstName}');
          },
          verificationFailed: (e) {
            if (scaffoldKey != null) {
              scaffoldKey.currentState
                  .showSnackBar(SnackBar(content: Text('${e.message}')));
            }
          },
          codeSent: (id, token) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PhoneVerificationScreen(id, appUser),
              ),
            );
          },
          codeAutoRetrievalTimeout: (id) {},
        );
      } else {
        result = 'USER_ALREADY_EXISTS';
      }
      return result;
    } catch (e) {
      print(e);
      print('Error!!!: Signing up with phone');
      return e;
    }
  }

  // login in with phone
  Future logInWithPhone(final String phoneNum, final AppUser appUser) async {
    try {
      var result;

      final _ref = FirebaseFirestore.instance;
      final _userRef =
          _ref.collection('users').where('phone', isEqualTo: phoneNum).limit(1);
      final _userSnap = await _userRef.get();

      if (_userSnap.docs.isNotEmpty) {
        await _auth.verifyPhoneNumber(
          phoneNumber: _phoneCode + phoneNum,
          verificationCompleted: (cred) async {
            final _result = await _auth.signInWithCredential(cred);
            final _user = _result.user;

            final _ref = FirebaseFirestore.instance;

            final _userRef = _ref.collection('users').doc(_user.uid);

            await _userRef.update({
              'account_type': appUser.accountType.index,
            });
            _userFromFirebase(_user);
            print('Success: Logging in user with name ${appUser.firstName}');
          },
          verificationFailed: (e) {
            if (scaffoldKey != null) {
              scaffoldKey.currentState
                  .showSnackBar(SnackBar(content: Text('${e.message}')));
            }
          },
          codeSent: (id, token) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PhoneVerificationScreen(id, appUser),
              ),
            );
          },
          codeAutoRetrievalTimeout: (id) {},
        );
      } else {
        result = 'USER_DOESNOT_EXIST';
      }

      return result;
    } catch (e) {
      print(e);
      print('Error!!!: Signing up with phone');
      return e;
    }
  }

  Future submitVerificationCode(
    final String verificationId,
    final String otpCode,
    final AppUser appUser,
  ) async {
    try {
      final _cred = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
      );

      final _userRef = _ref
          .collection('users')
          .where('phone', isEqualTo: appUser.phone)
          .limit(1);

      final _userSnap = await _userRef.get();

      if (_userSnap.docs.isEmpty) {
        final _result = await _auth.signInWithCredential(_cred);
        final _user = _result.user;

        appUser.uid = _user.uid;
        await UserProvider().sendUserToFirestore(appUser, _result.user.uid);
        await DynamicLinkProvider(_user.uid).handleDynamicLinks();
        _userFromFirebase(_user);
        print('Success: Signing up user with name ${appUser.firstName}');
      } else {
        final _result = await _auth.signInWithCredential(_cred);
        final _user = _result.user;

        final _ref = FirebaseFirestore.instance;

        final _userRef = _ref.collection('users').doc(_user.uid);

        await _userRef.update({
          'account_type': appUser.accountType.index,
        });
        _userFromFirebase(_user);
        print('Success: Logging in user with name ${appUser.firstName}');
      }
      return null;
    } catch (e) {
      print(e);
      print('Error!!!: Verifying user');
      return e;
    }
  }

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
      return null;
    } catch (e) {
      print(e);
      print(
          'Error!!!: Creating user with name ${appUser.firstName} ${appUser.lastName}');
      return e;
    }
  }

  // login with email and password
  Future loginWithEmailAndPassword({
    final String email,
    final String password,
    final AccountType accountType,
  }) async {
    try {
      final _result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      final _userRef = _ref.collection('users').doc(_result.user.uid);

      await _userRef.update({
        'account_type': accountType.index,
      });

      _userFromFirebase(_result.user);
      print('Success: Logging in user with email $email');
      return null;
    } catch (e) {
      print(e);
      print('Error!!!: Logging in user with email $email');
      return e;
    }
  }

  // sign up with google
  Future signUpWithGoogle({
    final AccountType accountType,
  }) async {
    try {
      final _account = await _googleSignIn.signIn();
      final _tokens = await _account.authentication;
      final _cred = GoogleAuthProvider.credential(
          idToken: _tokens.idToken, accessToken: _tokens.accessToken);
      final _result = await _auth.signInWithCredential(_cred);

      final _user = _result.user;

      final _appUser = AppUser(
        firstName: _user.displayName.split(' ')[0],
        lastName: _user.displayName.split(' ')[1],
        email: _user.email,
        uid: _result.user.uid,
        accountType: accountType,
      );

      final _ref = FirebaseFirestore.instance;

      final _userRef = _ref.collection('users').doc(_user.uid);

      final _userSnap = await _userRef.get();

      if (_userSnap.data() == null) {
        await UserProvider().sendUserToFirestore(_appUser, _result.user.uid);
        await DynamicLinkProvider(_appUser.uid).handleDynamicLinks();
        _userFromFirebase(_user);
        print('Success: Signing up user with name ${_user.displayName}');
      } else {
        await _userRef.update({
          'account_type': accountType.index,
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

  // reset password
  Future resetPassword(final String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      print('Success: Sending password reset email');
      return 'Success';
    } catch (e) {
      print(e);
      print('Error!!!: Sending password reset email');
      return null;
    }
  }

  // user from firebase
  AppUser _userFromFirebase(User user) {
    return user != null ? AppUser(uid: user.uid) : null;
  }

  // stream of user
  Stream<AppUser> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }
}
