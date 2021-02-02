import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:motel/models/firebase/user_model.dart';
import 'package:motel/viewmodels/auth_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/widgets/auth_widgets/auth_field.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';

class PhoneVerificationScreen extends StatelessWidget {
  final String verificationId;
  final AppUser user;
  PhoneVerificationScreen(this.verificationId, this.user);

  @override
  Widget build(BuildContext context) {
    return VmProvider<AuthVm>(
      vm: AuthVm(context),
      builder: (context, vm, appUser) {
        return Scaffold(
          key: vm.scaffoldKey,
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
                                _detailsBuilder(vm),
                                SizedBox(
                                  height: 30.0,
                                ),
                                AuthField(
                                  hintText: 'Your OTP code',
                                  controller: vm.otpController,
                                  type: TextInputType.number,
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                              ],
                            ),
                          ),
                          RoundedBtn(
                            title: 'Done',
                            onPressed: () => vm.submitVerificationCode(
                              verificationId,
                              user,
                            ),
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
      'Phone Verification',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 22.0,
      ),
    );
  }

  Widget _detailsBuilder(final AuthVm vm) {
    return Text(
      'Please enter your OTP code sent on number ${user.phone}',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
        color: Colors.black38,
      ),
    );
  }
}
