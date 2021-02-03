import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/viewmodels/withdraw_vm.dart';
import 'package:motel/views/widgets/auth_widgets/auth_field.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';

class WithdrawEarningScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VmProvider<WithdrawVm>(
      vm: WithdrawVm(context),
      builder: (context, vm, appUser) {
        return Scaffold(
          key: vm.scaffoldState,
          body: SafeArea(
            child: vm.showingProgressBar
                ? Center(
                    child: Lottie.asset('assets/lottie/loading.json'),
                  )
                : GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _appbarBuilder(context),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _verificationTextBuilder(),
                                SizedBox(
                                  height: 10.0,
                                ),
                                _detailsBuilder(appUser),
                                SizedBox(
                                  height: 30.0,
                                ),
                                AuthField(
                                  hintText: 'Easy Paisa Number',
                                  controller: vm.easyPaisa,
                                  type: TextInputType.number,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                AuthField(
                                  hintText: 'Bank Account Number',
                                  controller: vm.bankAccountNum,
                                  type: TextInputType.number,
                                ),
                                SizedBox(
                                  height: 20.0,
                                ),
                                AuthField(
                                  hintText:
                                      'Your amount (max Rs ${appUser.earnings})',
                                  controller: vm.amountController,
                                  type: TextInputType.number,
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                              ],
                            ),
                          ),
                          RoundedBtn(
                            title: 'Withdraw',
                            onPressed: () => vm.withdrawAmount(appUser),
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _appbarBuilder(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => Navigator.pop(context),
    );
  }

  Widget _verificationTextBuilder() {
    return Text(
      'Withdraw Earnings',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 22.0,
      ),
    );
  }

  Widget _detailsBuilder(final AppUser appUser) {
    return Text(
      'Please enter the amount you want to withdraw along with your easy paisa number OR bank account number. Your payment will be processed after Spott Up team reviews it.',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
        color: Colors.black38,
      ),
    );
  }
}
