import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motel/views/screens/auth/login_screen.dart';
import 'package:motel/views/screens/get_started_screen.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/welcome_img.jpg',
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _hotelDetailBuilder(),
              _btnBuilder(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hotelDetailBuilder() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 80.0,
              height: 80.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300],
                    offset: Offset(
                      0.0,
                      0.0,
                    ),
                    blurRadius: 20.0,
                  ),
                ],
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/svgs/travel.svg',
                  width: 50.0,
                  height: 50.0,
                  color: Color(0xff45ad90),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Spott Up',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(
              'Best hotel deals for your holiday',
            ),
          ],
        ),
      ),
    );
  }

  Widget _btnBuilder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        children: <Widget>[
          RoundedBtn(
            title: 'Get started',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => GetStartedScreen(),
                ),
              );
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LoginScreen(),
                ),
              );
            },
            child: Text(
              'Already have an account? Login',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
