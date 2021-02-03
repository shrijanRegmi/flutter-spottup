import 'package:flutter/material.dart';
import 'package:motel/models/firebase/notification_model.dart';

class ViewWithdrawRequestScreen extends StatelessWidget {
  final AppNotification notification;
  ViewWithdrawRequestScreen(this.notification);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
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
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _verificationTextBuilder(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _detailsBuilder(),
                      SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
              ],
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

  Widget _verificationTextBuilder() {
    return Text(
      'Earnings Withdraw',
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 22.0,
      ),
    );
  }

  Widget _detailsBuilder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${notification.user.firstName} ${notification.user.lastName} wants to withdraw his earnings from Spott Up app.',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14.0,
            color: Colors.black38,
          ),
        ),
        SizedBox(
          height: 50.0,
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              fontFamily: 'Nunito',
            ),
            children: [
              TextSpan(
                text: 'Easy Paisa Number : ',
              ),
              TextSpan(
                text:
                    '${notification.easyPaisaNum == '' ? 'N/A' : notification.easyPaisaNum}',
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              fontFamily: 'Nunito',
            ),
            children: [
              TextSpan(
                text: 'Bank Account Number : ',
              ),
              TextSpan(
                text:
                    '${notification.bankAccountNum == '' ? 'N/A' : notification.bankAccountNum}',
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              fontFamily: 'Nunito',
            ),
            children: [
              TextSpan(
                text: 'Amount : ',
              ),
              TextSpan(
                text: 'Rs ${notification.amount}',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
