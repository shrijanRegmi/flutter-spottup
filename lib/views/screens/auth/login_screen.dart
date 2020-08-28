import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:motel/viewmodels/auth_vm.dart';
import 'package:motel/viewmodels/vm_provider.dart';
import 'package:motel/views/widgets/auth_widgets/auth_field.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VmProvider<AuthVm>(
      vm: AuthVm(),
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
                                  _loginTextBuilder(),
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
                                  _authContainerBuilder(
                                      vm.emailController, vm.passController),
                                  SizedBox(
                                    height: 40.0,
                                  ),
                                  _loginBtnBuilder(
                                      vm.loginWithEmailAndPassword),
                                  SizedBox(
                                    height: 50.0,
                                  ),
                                  // _hotelOwnerAccountChoose(),
                                  // SizedBox(
                                  //   height: 10.0,
                                  // ),
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

  Widget _loginTextBuilder() {
    return Text(
      'Login',
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
      onPressed: () => googleSignUp(isLogin: true),
    );
  }

  Widget _emailLoginText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'or login with email',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12.0,
            color: Colors.black38,
          ),
        ),
      ],
    );
  }

  Widget _hotelOwnerAccountChoose() {
    return GestureDetector(
      onTap: () {
        // Navigator.push(context, route);
      },
      child: Container(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'I want to login as Hotel Owner',
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

  Widget _authContainerBuilder(final TextEditingController _emailController,
      final TextEditingController _passController) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: <Widget>[
          AuthField(
            hintText: 'Your Email',
            type: TextInputType.emailAddress,
            controller: _emailController,
          ),
          SizedBox(
            height: 20.0,
          ),
          AuthField(
            hintText: 'Password',
            isPassword: true,
            controller: _passController,
          ),
        ],
      ),
    );
  }

  Widget _loginBtnBuilder(final Function loginUser) {
    return RoundedBtn(
      title: 'Login',
      padding: 0.0,
      onPressed: loginUser,
    );
  }
}
