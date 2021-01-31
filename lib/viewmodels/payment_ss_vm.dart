import 'package:flutter/material.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/user_provider.dart';

class PaymentSsVm extends ChangeNotifier {
  var _isConfirmed = false;
  var _isDeclined = false;

  bool get isConfirmed => _isConfirmed;
  bool get isDeclined => _isDeclined;

  // init function
  onInit(final AppUser user) {
    if (user != null && user.invitationFrom != null) {
      _updateIsConfirmed(user.invitationFrom.isConfirmed);
      _updateIsDecline(user.invitationFrom.isDeclined);
    }
  }

  // confirm to pay
  confirmToPay(
      final AppUser user, final String userId, final int earning) async {
    _updateIsConfirmed(true);
    _updateIsDecline(false);
    await UserProvider(uid: user.uid)
        .confirmPayment(earning, userId, user.invitationFrom);
  }

  // decline to pay
  declineToPay(final AppUser user) async {
    _updateIsDecline(true);
    _updateIsConfirmed(false);
    await UserProvider(uid: user.uid).declineToPay(user.invitationFrom);
  }

  // update value of is confimed
  _updateIsConfirmed(final bool newVal) {
    _isConfirmed = newVal;
    notifyListeners();
  }

  // update value of is declined
  _updateIsDecline(final bool newVal) {
    _isDeclined = newVal;
    notifyListeners();
  }
}
