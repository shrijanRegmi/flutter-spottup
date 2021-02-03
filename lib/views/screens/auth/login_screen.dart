import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:motel/enums/account_type.dart';
import 'package:motel/viewmodels/auth_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/screens/auth/create_account_screen.dart';
import 'package:motel/views/screens/auth/forget_password_screen.dart';
import 'package:motel/views/widgets/auth_widgets/auth_field.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';

class LoginScreen extends StatelessWidget {
  final AccountType accountType;
  LoginScreen({this.accountType = AccountType.general});

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
                      color: Colors.transparent,
                      height: MediaQuery.of(context).size.height,
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
                                  _loginTextBuilder(vm),
                                  SizedBox(
                                    height: 30.0,
                                  ),
                                  _googleSignInBuilder(vm.googleSignUp),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  _emailLoginText(),
                                  SizedBox(
                                    height: 20.0,
                                  ),
                                  _authContainerBuilder(vm.phoneController),
                                  SizedBox(
                                    height: 50.0,
                                  ),
                                  // _forgotPasswordTextBuilder(context),
                                  // SizedBox(
                                  //   height: 20.0,
                                  // ),
                                  _loginBtnBuilder(vm.logInWithPhone),
                                  SizedBox(
                                    height: 50.0,
                                  ),
                                  if (accountType != AccountType.general)
                                    _signUpTextBuilder(context),
                                  if (accountType != AccountType.general)
                                    SizedBox(height: 20.0),
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

  Widget _loginTextBuilder(AuthVm vm) {
    return Text(
      vm.getAuthText(accountType),
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

  Widget _emailLoginText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'or login with phone',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12.0,
            color: Colors.black38,
          ),
        ),
      ],
    );
  }

  // Widget _forgotPasswordTextBuilder(BuildContext context) {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.end,
  //     children: <Widget>[
  //       GestureDetector(
  //         onTap: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (_) => ForgotPasswordScreen(),
  //             ),
  //           );
  //         },
  //         child: Container(
  //           color: Colors.transparent,
  //           child: Text(
  //             'Forgot Password ?',
  //             style: TextStyle(
  //               fontWeight: FontWeight.w600,
  //               fontSize: 14.0,
  //               color: Colors.black38,
  //             ),
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _signUpTextBuilder(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CreateAccountScreen(
              accountType: accountType,
            ),
          ),
        );
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Don't have an account ? Sign Up here",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12.0,
                color: Colors.black38,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _authContainerBuilder(final TextEditingController _phoneController) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: <Widget>[
          AuthField(
            hintText: 'Phone eg: +921234567890',
            type: TextInputType.phone,
            controller: _phoneController,
          ),
        ],
      ),
    );
  }

  Widget _loginBtnBuilder(final Function loginUser) {
    return RoundedBtn(
      title: 'Login',
      padding: 0.0,
      onPressed: () => loginUser(accountType),
    );
  }
}
