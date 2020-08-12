import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motel/views/screens/auth/create_account_screen.dart';
import 'package:motel/views/screens/auth/login_screen.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';

class GetStartedScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _textAndImgBuilder(context),
              _btnBuilder(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textAndImgBuilder(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 50.0,
        ),
        SvgPicture.asset(
          'assets/svgs/world_tour.svg',
          width: MediaQuery.of(context).size.width - 120,
          height: MediaQuery.of(context).size.width - 120,
        ),
        SizedBox(
          height: 40.0,
        ),
        Text(
          'Plan your trips',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22.0,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          'Book one of your unique hotel to\nescape the ordinary',
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

  Widget _btnBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        children: <Widget>[
          RoundedBtn(
            title: 'Login',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginScreen(),
                ),
              );
            },
          ),
          SizedBox(
            height: 10.0,
          ),
          RoundedBtn(
            title: 'Create Account',
            color: Colors.white,
            textColor: Color(0xff292626),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CreateAccountScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
