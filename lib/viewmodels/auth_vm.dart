import 'package:flutter/material.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/auth/auth_provider.dart';

class AuthVm extends ChangeNotifier {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController get emailController => _emailController;
  TextEditingController get passController => _passController;
  TextEditingController get firstNameController => _firstNameController;
  TextEditingController get lastNameController => _lastNameController;
  TextEditingController get phoneController => _phoneController;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  // login with email and password
  Future loginWithEmailAndPassword() async {
    final _email = _emailController.text.trim();
    final _pass = _passController.text.trim();

    if (_email != '' && _pass != '') {
      return await AuthProvider().loginWithEmailAndPassword(
        email: _email,
        password: _pass,
      );
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Please fill up all fields to continue',
        ),
      ));
    }
  }

  // login with email and password
  Future signUpWithEmailAndPassword() async {
    final _email = _emailController.text.trim();
    final _pass = _passController.text.trim();
    final _firstName = _firstNameController.text.trim();
    final _lastName = _lastNameController.text.trim();
    final _phone = _phoneController.text.trim();

    if (_email != '' &&
        _pass != '' &&
        _firstName != '' &&
        _lastName != '' &&
        _phone != '') {
      final _appUser = AppUser(
        firstName: _firstName,
        lastName: _lastName,
        phone: int.parse(_phone),
        email: _email,
      );

      return await AuthProvider().signUpWithEmailAndPassword(
        appUser: _appUser,
        password: _pass,
      );
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Please fill up all fields to continue',
        ),
      ));
    }
  }
}
