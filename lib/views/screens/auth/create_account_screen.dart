import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:motel/enums/account_type.dart';
import 'package:motel/viewmodels/auth_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/widgets/auth_widgets/auth_field.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';

class CreateAccountScreen extends StatelessWidget {
  final AccountType accountType;
  CreateAccountScreen({this.accountType = AccountType.general});

  @override
  Widget build(BuildContext context) {
    return VmProvider<AuthVm>(
      vm: AuthVm(context),
      builder: (context, vm, appUser) {
        return Scaffold(
          key: vm.scaffoldKey,
          backgroundColor: Color(0xffEEEEEE),
          body: SafeArea(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: vm.showingProgressBar
                  ? Center(
                      child: Lottie.asset('assets/lottie/loading.json'),
                    )
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      color: Colors.transparent,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _appbarBuilder(context),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  _signUpTextBuilder(vm),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  _googleSignInBuilder(vm.googleSignUp),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  _emailSignUpText(),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  _authContainerBuilder(vm),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  _singUpBtnBuilder(
                                    vm.signUpWithPhone,
                                  ),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  _policyTextBuilder(),
                                  SizedBox(
                                    height: 50.0,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
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

  Widget _signUpTextBuilder(AuthVm vm) {
    return Text(
      vm.getAuthText(accountType, auth: 'Sign Up'),
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 22.0,
      ),
    );
  }

  Widget _googleSignInBuilder(final Function googleSignUp) {
    return RoundedBtn(
      title: 'Google',
      color: Color(0xfffde4343),
      padding: 0.0,
      onPressed: () => googleSignUp(accountType),
    );
  }

  Widget _emailSignUpText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'or sign up with phone',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12.0,
            color: Colors.black38,
          ),
        ),
      ],
    );
  }

  Widget _authContainerBuilder(AuthVm vm) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: <Widget>[
          AuthField(
            hintText: 'First Name',
            requireWordCapitalization: true,
            controller: vm.firstNameController,
          ),
          SizedBox(
            height: 20.0,
          ),
          AuthField(
            hintText: 'Last Name',
            requireWordCapitalization: true,
            controller: vm.lastNameController,
          ),
          SizedBox(
            height: 20.0,
          ),
          AuthField(
            hintText: 'Phone eg: 1234567890',
            type: TextInputType.phone,
            controller: vm.phoneController,
          ),
        ],
      ),
    );
  }

  Widget _singUpBtnBuilder(Function signUpUser) {
    return RoundedBtn(
      title: 'Sign Up',
      padding: 0.0,
      onPressed: () => signUpUser(accountType),
    );
  }

  Widget _policyTextBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'By signing up, you agreed with our Terms Of\nServices and Privacy Policy.',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12.0,
            color: Colors.black38,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
