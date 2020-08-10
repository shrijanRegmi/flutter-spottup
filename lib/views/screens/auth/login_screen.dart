import 'package:flutter/material.dart';
import 'package:motel/views/screens/home/home_screen.dart';
import 'package:motel/views/widgets/auth_widgets/auth_field.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffEEEEEE),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _appbarBuilder(context),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _loginTextBuilder(),
                        SizedBox(
                          height: 30.0,
                        ),
                        _googleSignInBuilder(),
                        SizedBox(
                          height: 20.0,
                        ),
                        _emailLoginText(),
                        SizedBox(
                          height: 20.0,
                        ),
                        _authContainerBuilder(),
                        SizedBox(
                          height: 40.0,
                        ),
                        _loginBtnBuilder(context),
                        SizedBox(
                          height: 10.0,
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

  Widget _googleSignInBuilder() {
    return RoundedBtn(
      title: 'Google',
      color: Color(0xfffde4343),
      padding: 0.0,
      onPressed: () {},
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

  Widget _authContainerBuilder() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        children: <Widget>[
          AuthField(
            hintText: 'Your Email',
            type: TextInputType.emailAddress,
          ),
          SizedBox(
            height: 20.0,
          ),
          AuthField(
            hintText: 'Password',
            isPassword: true,
          ),
        ],
      ),
    );
  }

  Widget _loginBtnBuilder(BuildContext context) {
    return RoundedBtn(
      title: 'Login',
      padding: 0.0,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(),
          ),
        );
      },
    );
  }
}
