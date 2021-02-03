import 'package:flutter/material.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/services/firestore/user_provider.dart';

class WithdrawVm extends ChangeNotifier {
  final BuildContext context;
  WithdrawVm(this.context);

  TextEditingController _amountController = TextEditingController();
  TextEditingController _easyPaisa = TextEditingController();
  TextEditingController _bankAccountNum = TextEditingController();
  bool _showingProgressBar = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  TextEditingController get amountController => _amountController;
  TextEditingController get easyPaisa => _easyPaisa;
  TextEditingController get bankAccountNum => _bankAccountNum;
  bool get showingProgressBar => _showingProgressBar;
  GlobalKey<ScaffoldState> get scaffoldState => _scaffoldKey;

  // withdraw amount
  withdrawAmount(final AppUser appUser) async {
    if (_amountController.text.trim() != '' &&
        int.parse(_amountController.text.trim()) > 0 &&
        int.parse(_amountController.text.trim()) <= appUser.earnings) {
      if (_easyPaisa.text.trim() == '' && _bankAccountNum.text.trim() == '') {
        _scaffoldKey.currentState.showSnackBar(
          SnackBar(
            content: Text(
                'Please provide either your easy paisa number or your bank account number.'),
          ),
        );
      } else {
        updateProgressBar(true);

        final _result = await UserProvider(uid: appUser.uid).withdrawPayment(
          _amountController.text.trim(),
          _easyPaisa.text.trim(),
          _bankAccountNum.text.trim(),
        );

        if (_result.toString().contains('Success')) {
          Navigator.pop(context);
        } else {
          updateProgressBar(false);
        }
      }
    }
  }

  // update value of progressbar
  updateProgressBar(final bool newVal) {
    _showingProgressBar = newVal;
  }
}
