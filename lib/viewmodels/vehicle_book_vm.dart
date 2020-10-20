import 'package:flutter/material.dart';
import 'package:motel/models/firebase/confirm_booking_model.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/user_provider.dart';
import 'package:provider/provider.dart';

class VehicleBookVm extends ChangeNotifier {
  final BuildContext context;
  VehicleBookVm(this.context);

  ScrollController _scrollController = ScrollController();
  TextEditingController _femaleController = TextEditingController();
  TextEditingController _kidController = TextEditingController();
  TextEditingController _maleController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _daysController = TextEditingController();
  bool _isPersonConfirmed = false;
  bool _isDetailsConfirmed = false;
  bool _isProcessing = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController get scrollController => _scrollController;
  TextEditingController get maleController => _maleController;
  TextEditingController get femaleController => _femaleController;
  TextEditingController get kidController => _kidController;
  TextEditingController get emailController => _emailController;
  TextEditingController get phoneController => _phoneController;
  TextEditingController get daysController => _daysController;
  bool get isDetailsConfirmed => _isDetailsConfirmed;
  bool get isPersonConfirmed => _isPersonConfirmed;
  bool get isProcessing => _isProcessing;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  // update value of is details confirmed
  updateIsDetailsConfirmed(final _newVal) {
    _isDetailsConfirmed = _newVal;
    notifyListeners();
  }

  // update value of is person confirmed
  updateIsPersonConfirmed(final _newVal) {
    _isPersonConfirmed = _newVal;
    if (_newVal) {
      _scrollController.animateTo(
        MediaQuery.of(context).size.height,
        duration: Duration(milliseconds: 1000),
        curve: Curves.ease,
      );
    }
    notifyListeners();
  }

  // confirm booking
  confirmBooking(
      final ConfirmVehicleBooking booking, final AppUser appUser) async {
    _isProcessing = true;
    notifyListeners();
    try {
      await UserProvider(uid: appUser.uid).confirmVehicleBooking(booking);
      _isProcessing = false;
      notifyListeners();
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.pop(context);
      print('Success: Sending email');
      bookingDoneDialog();
    } catch (e) {
      print(e);
      print('Error!!!: Sending email');
      _isProcessing = false;
      notifyListeners();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Unexpected error occured ! Please try booking again !',
        ),
      ));
      return null;
    }
  }

  // dialog when booking is done
  bookingDoneDialog() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Text(
              'Thank You',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              width: 5.0,
            ),
            Icon(
              Icons.check,
              color: Color(0xff45ad90),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'We have received your booking with Spott Up app. Our customer service representative will contact you soon.'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Color(0xff45ad90),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // check email phone
  checkEmailPhone() {
    FocusScope.of(context).unfocus();
    if (!_isDetailsConfirmed) {
      final _appUser = Provider.of<AppUser>(context, listen: false);
      final _fullName = '${_appUser.firstName} ${_appUser.lastName}';

      if (_emailController.text.trim() == _fullName &&
          _phoneController.text.trim() == _appUser.phone.toString()) {
        _isDetailsConfirmed = true;
      } else if (_emailController.text.trim() != _fullName &&
          _phoneController.text.trim() != _appUser.phone.toString()) {
        confirmationDialog(
          "Your name and phone doesn't match your profile",
          "Your name '${_appUser.firstName} ${_appUser.lastName}' from your profile does not match '${_emailController.text.trim()}'.\n\nYour phone '${_appUser.phone}' from your profile does not match '${_phoneController.text.trim()}'.",
        );
      } else if (_emailController.text.trim() != _fullName) {
        confirmationDialog(
          "Your name doesn't match your profile",
          "Your name '${_appUser.firstName} ${_appUser.lastName}' from your profile does not match '${_emailController.text.trim()}'.",
        );
      } else if (_phoneController.text.trim() != _appUser.phone.toString()) {
        confirmationDialog(
          "Your phone doesn't match your profile",
          "Your phone '${_appUser.phone}' from your profile does not match '${_phoneController.text.trim()}'.",
        );
      }
    }

    if (_isDetailsConfirmed) {
      _scrollController.animateTo(
        MediaQuery.of(context).size.height + 200,
        duration: Duration(milliseconds: 1000),
        curve: Curves.ease,
      );
    }
    notifyListeners();
  }

  // confirmation failed dialog
  confirmationDialog(final String title, final String content) async {
    return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: Text(
          '$title',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('$content'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Cancle',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
            child: InkWell(
              onTap: () {
                _isDetailsConfirmed = true;
                _scrollController.animateTo(
                  MediaQuery.of(context).size.height + 200.0,
                  duration: Duration(milliseconds: 1000),
                  curve: Curves.ease,
                );
                notifyListeners();
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text(
                  'Confirm Anyway',
                  style: TextStyle(
                    color: Color(0xff45ad90),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
