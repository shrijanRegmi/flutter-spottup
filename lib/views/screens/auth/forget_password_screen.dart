import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:motel/viewmodels/auth_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/widgets/auth_widgets/auth_field.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VmProvider<AuthVm>(
      vm: AuthVm(),
      builder: (context, vm, appUser) {
        return Scaffold(
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
                                _forgetPasswordTextBuilder(),
                                SizedBox(
                                  height: 10.0,
                                ),
                                _detailsBuilder(),
                                SizedBox(
                                  height: 30.0,
                                ),
                                AuthField(
                                  hintText: 'Your email',
                                  controller: vm.emailController,
                                ),
                                SizedBox(
                                  height: 30.0,
                                ),
                              ],
                            ),
                          ),
                          RoundedBtn(
                            title: 'Send',
                            onPressed: () => vm.resetPassword(context),
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

  Widget _forgetPasswordTextBuilder() {
    return Text(
      'Forget Password',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 22.0,
      ),
    );
  }

  Widget _detailsBuilder() {
    return Text(
      'Enter your email to receive an email to reset your password.',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14.0,
        color: Colors.black38,
      ),
    );
  }
}
