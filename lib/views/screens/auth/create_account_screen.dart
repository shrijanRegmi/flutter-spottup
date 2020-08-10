import 'package:flutter/material.dart';
import 'package:motel/views/screens/auth/login_screen.dart';
import 'package:motel/views/widgets/auth_widgets/auth_field.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';

class CreateAccountScreen extends StatelessWidget {
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
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
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
                        _signUpTextBuilder(),
                        SizedBox(
                          height: 30.0,
                        ),
                        _googleSignInBuilder(),
                        SizedBox(
                          height: 20.0,
                        ),
                        _emailSignUpText(),
                        SizedBox(
                          height: 20.0,
                        ),
                        _authContainerBuilder(),
                        SizedBox(
                          height: 20.0,
                        ),
                        _singUpBtnBuilder(),
                        SizedBox(
                          height: 20.0,
                        ),
                        _policyTextBuilder(),
                        SizedBox(
                          height: 20.0,
                        ),
                        _loginTextSection(context),
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

  Widget _signUpTextBuilder() {
    return Text(
      'Sign Up',
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

  Widget _emailSignUpText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'or sign up with email',
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
            hintText: 'First Name',
            requireWordCapitalization: true,
          ),
          SizedBox(
            height: 20.0,
          ),
          AuthField(
            hintText: 'Last Name',
            requireWordCapitalization: true,
          ),
          SizedBox(
            height: 20.0,
          ),
          AuthField(
            hintText: 'Phone Number',
            type: TextInputType.phone,
          ),
          SizedBox(
            height: 20.0,
          ),
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

  Widget _singUpBtnBuilder() {
    return RoundedBtn(
      title: 'Sign Up',
      padding: 0.0,
      onPressed: () {},
    );
  }

  Widget _policyTextBuilder() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'By signing up, you agreed with our terms of\nServices and Privacy Policy',
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

  Widget _loginTextSection(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LoginScreen(),
              ),
            );
          },
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12.0,
                color: Colors.black38,
                fontFamily: 'Nunito',
              ),
              children: [
                TextSpan(
                  text: 'Already have an account? ',
                ),
                TextSpan(
                  text: 'Login',
                  style: TextStyle(
                    color: Color(0xff45ad90),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
