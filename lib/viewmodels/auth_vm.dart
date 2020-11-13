import 'package:flutter/material.dart';
import 'package:motel/enums/account_type.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/auth/auth_provider.dart';

class AuthVm extends ChangeNotifier {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showingProgressBar = false;

  TextEditingController get emailController => _emailController;
  TextEditingController get passController => _passController;
  TextEditingController get firstNameController => _firstNameController;
  TextEditingController get lastNameController => _lastNameController;
  TextEditingController get phoneController => _phoneController;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  bool get showingProgressBar => _showingProgressBar;

  // login with email and password
  Future loginWithEmailAndPassword({
    final AccountType accountType,
  }) async {
    _updateProgressBar(true);
    final _email = _emailController.text.trim();
    final _pass = _passController.text.trim();

    var _result;

    if (_email != '' && _pass != '') {
      _result = await AuthProvider().loginWithEmailAndPassword(
        email: _email,
        password: _pass,
        accountType: accountType,
      );
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Please fill up all fields to continue',
        ),
      ));
    }
    if (_result == null) {
      _updateProgressBar(false);
    }
  }

  // sign up with email and password
  Future signUpWithEmailAndPassword(
    final AccountType accountType,
  ) async {
    _updateProgressBar(true);

    final _email = _emailController.text.trim();
    final _pass = _passController.text.trim();
    final _firstName = _firstNameController.text.trim();
    final _lastName = _lastNameController.text.trim();
    final _phone = _phoneController.text.trim();

    var _result;

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
        accountType: accountType,
      );

      _result = await AuthProvider().signUpWithEmailAndPassword(
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
    if (_result == null) {
      _updateProgressBar(false);
    }
  }

  // sign up with google
  Future googleSignUp(
    final AccountType accountType,
  ) async {
    _updateProgressBar(true);

    final _result =
        await AuthProvider().signUpWithGoogle(accountType: accountType);

    if (_result == null) {
      _updateProgressBar(false);
    }
    return _result;
  }

  // reset password
  resetPassword(BuildContext context) async {
    if (_emailController.text.trim() != '') {
      _updateProgressBar(true);

      final _email = _emailController.text.trim();
      _emailController.clear();
      final _result = await AuthProvider().resetPassword(_email);
      if (_result != null) {
        Navigator.pop(context);
        _showResetSuccessDialog(context);
      }
    }
  }

  // show reset dialog
  _showResetSuccessDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Successful'),
        content: Text(
          'We have sent a password recovery link in your email. Please check your email',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xff45ad90),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // update progress bar
  _updateProgressBar(final bool newVal) {
    _showingProgressBar = newVal;
    notifyListeners();
  }

  // get auth text
  getAuthText(final AccountType accountType, {final String auth = 'Login'}) {
    switch (accountType) {
      case AccountType.general:
        return '$auth';
        break;
      case AccountType.hotelPartner:
        return '$auth - Hotel Partner';
        break;
      case AccountType.tourPartner:
        return '$auth - Tour Partner';
        break;
      case AccountType.vehiclePartner:
        return '$auth - Car/Bus Partner';
        break;
      default:
        return '$auth';
    }
  }
}
