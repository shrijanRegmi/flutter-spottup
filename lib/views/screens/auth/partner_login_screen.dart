import 'package:flutter/material.dart';
import 'package:motel/enums/account_type.dart';
import 'package:motel/views/screens/auth/login_screen.dart';
import 'package:motel/views/widgets/common_widgets/rounded_btn.dart';

class PartnerLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _appbarBuilder(context),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _partnerTextBuilder(),
                    SizedBox(
                      height: 30.0,
                    ),
                    _btnsBuilder(context),
                  ],
                ),
              ),
            ],
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

  Widget _partnerTextBuilder() {
    return Text(
      'Become a Partner',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 22.0,
      ),
    );
  }

  Widget _btnsBuilder(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RoundedBtn(
          title: 'Hotel Partner Login',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LoginScreen(
                  accountType: AccountType.hotelPartner,
                ),
              ),
            );
          },
        ),
        SizedBox(
          height: 20.0,
        ),
        RoundedBtn(
          title: 'Tour Partner Login',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LoginScreen(
                  accountType: AccountType.tourPartner,
                ),
              ),
            );
          },
        ),
        SizedBox(
          height: 20.0,
        ),
        RoundedBtn(
          title: 'Car/Bus Partner Login',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LoginScreen(
                  accountType: AccountType.vehiclePartner,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
