import 'package:flutter/material.dart';
import 'package:motel/enums/account_type.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/auth/auth_provider.dart';
import 'package:motel/services/dynamic_link_provider.dart';

class AuthVm extends ChangeNotifier {
  final BuildContext context;
  AuthVm(this.context);

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _otpController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showingProgressBar = false;

  TextEditingController get emailController => _emailController;
  TextEditingController get passController => _passController;
  TextEditingController get firstNameController => _firstNameController;
  TextEditingController get lastNameController => _lastNameController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get otpController => _otpController;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  bool get showingProgressBar => _showingProgressBar;

  // login with email and password
  Future loginWithEmailAndPassword({
    final AccountType accountType,
  }) async {
    final _email = _emailController.text.trim();
    final _pass = _passController.text.trim();

    var _result;

    if (_email != '' && _pass != '') {
      _updateProgressBar(true);
      _result = await AuthProvider().loginWithEmailAndPassword(
        email: _email,
        password: _pass,
        accountType: accountType,
      );
      if (_result != null) {
        _showErrorMessage(_result.code);
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Please fill up all fields to continue',
        ),
      ));
    }
    if (_result != null) {
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
        phone: _phone,
        email: _email,
        accountType: accountType,
      );

      _result = await AuthProvider().signUpWithEmailAndPassword(
        appUser: _appUser,
        password: _pass,
      );

      await DynamicLinkProvider(_appUser.uid).handleDynamicLinks();

      if (_result != null) {
        _showErrorMessage(_result.code);
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Please fill up all fields to continue',
        ),
      ));
    }

    if (_result != null) {
      _updateProgressBar(false);
    }
  }

  // login with phone
  Future logInWithPhone(
    final AccountType accountType,
  ) async {
    final _phone = _phoneController.text.trim();

    var _result;

    if (_phone != '') {
      if (_phone.contains('+')) {
        _updateProgressBar(true);

        final _appUser = AppUser(
          phone: _phone,
          accountType: accountType,
        );

        _result = await AuthProvider(
          scaffoldKey: _scaffoldKey,
          context: context,
        ).logInWithPhone('$_phone', _appUser);

        if (_result != null) {
          _showErrorMessage(_result);
        }
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'Your phone number is missing "+" sign. Please provide a valid phone number along with proper country code.',
          ),
        ));
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Please provide your phone number to continue.',
        ),
      ));
    }

    if (_result != null) {
      _updateProgressBar(false);
    }
  }

  // sign up with phone
  Future signUpWithPhone(
    final AccountType accountType,
  ) async {
    final _firstName = _firstNameController.text.trim();
    final _lastName = _lastNameController.text.trim();
    final _phone = _phoneController.text.trim();

    var _result;

    if (_firstName != '' && _lastName != '' && _phone != '') {
      if (_phone.contains('+')) {
        _updateProgressBar(true);

        final _appUser = AppUser(
          firstName: _firstName,
          lastName: _lastName,
          phone: _phone,
          accountType: accountType,
        );

        _result = await AuthProvider(
          scaffoldKey: _scaffoldKey,
          context: context,
        ).signUpWithPhone('$_phone', _appUser);

        if (_result != null) {
          _showErrorMessage(_result);
        }
      } else {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(
            'Your phone number is missing "+" sign. Please provide a valid phone number along with proper country code.',
          ),
        ));
      }
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Please fill up all fields to continue',
        ),
      ));
    }

    if (_result != null) {
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

  _showErrorMessage(final error) {
    print(error);
    String _errorText = '';
    switch (error) {
      case 'ERROR_EMAIL_ALREADY_IN_USE':
        _errorText =
            'Email already in use. Please use a different email or login with that email.';
        break;
      case 'ERROR_INVALID_EMAIL':
        _errorText = 'The email you provided is not valid.';
        break;
      case 'ERROR_WEAK_PASSWORD':
        _errorText = 'The password you provided is too weak.';
        break;
      case 'ERROR_USER_NOT_FOUND':
        _errorText =
            'User with that email not found. Please create an account with that email first.';
        break;
      case 'ERROR_WRONG_PASSWORD':
        _errorText = 'The password you provided is not correct.';
        break;
      case 'USER_ALREADY_EXISTS':
        _errorText =
            'Phone number already in use. Please use a different number or try to login with that number.';
        break;
      case 'USER_DOESNOT_EXIST':
        _errorText =
            'User with that phone number not found. Please create an account with that number first.';
        break;
      default:
        _errorText = 'Unexpected error occured! Please try again.';
    }

    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(
        '$_errorText',
      ),
    ));
  }

  // submit verification code
  submitVerificationCode(final String verificationId, final AppUser appUser,
      final bool isSignUp) async {
    if (_otpController.text.trim() != '') {
      _updateProgressBar(true);
      final _result = await AuthProvider(context: context)
          .submitVerificationCode(
              verificationId, _otpController.text.trim(), appUser);

      if (_result != null) {
        _updateProgressBar(false);
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(_result.toString().contains(
                    'The sms verification code used to create the phone auth credential is invalid. Please resend the verification code sms and be sure use the verification code provided by the user')
                ? 'Invalid verification code.'
                : '$_result'),
          ),
        );
      } else {
        if (isSignUp) {
          await DynamicLinkProvider(appUser.uid).handleDynamicLinks();
        }
      }
    }
  }
}
