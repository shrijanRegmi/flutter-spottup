import 'package:flutter/material.dart';

class BookVm extends ChangeNotifier {
  final BuildContext context;
  BookVm({@required this.context});

  DateTime _checkInDate;
  DateTime _checkOutDate;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  bool _isBookingAvailable = false;
  bool _isEmailPhoneConfirmed = false;
  ScrollController _scrollController = ScrollController();

  DateTime get checkInDate => _checkInDate;
  DateTime get checkOutDate => _checkOutDate;
  TextEditingController get emailController => _emailController;
  TextEditingController get phoneController => _phoneController;
  bool get isBookingAvailable => _isBookingAvailable;
  bool get isEmailPhoneConfirmed => _isEmailPhoneConfirmed;
  ScrollController get scrollController => _scrollController;

  // show checkin dialog
  Future showCheckInDialog() async {
    final _pickedDate = await showDatePicker(
      context: context,
      initialDate: _checkInDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2100),
    );
    if (_pickedDate != null) {
      _checkInDate = _pickedDate;
      notifyListeners();
    }
  }

  // show checkin dialog
  Future showCheckOutDialog() async {
    final _pickedDate = await showDatePicker(
      context: context,
      initialDate: _checkOutDate ?? DateTime.now(),
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2100),
    );
    if (_pickedDate != null) {
      _checkOutDate = _pickedDate;
      notifyListeners();
    }
  }

  // check availability of booking
  checkAvailability() {
    _isBookingAvailable = true;
    if (_isEmailPhoneConfirmed) {
      _scrollController.animateTo(
        MediaQuery.of(context).size.height,
        duration: Duration(milliseconds: 1000),
        curve: Curves.ease,
      );
    }
    notifyListeners();
  }

  // check email phone
  checkEmailPhone() {
    _isEmailPhoneConfirmed = true;
    if (_isBookingAvailable) {
      _scrollController.animateTo(
        MediaQuery.of(context).size.height,
        duration: Duration(milliseconds: 1000),
        curve: Curves.ease,
      );
    }
    notifyListeners();
  }
}
