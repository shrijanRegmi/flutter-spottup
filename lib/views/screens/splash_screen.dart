import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                Lottie.asset('assets/lottie/main_loading.json'),
                Positioned.fill(
                  top: 140.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Spott Up',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Hotels and much more..',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
