import 'package:e_health/screen/auth/login_checker.dart';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Center(
        child: Column(
          children: [
            Lottie.asset("assets/splash.json"),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "E Health",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
      splashTransition: SplashTransition.sizeTransition,
      pageTransitionType: PageTransitionType.bottomToTop,
      splashIconSize: 400,
      nextScreen: const LoginChecker(),
      backgroundColor: const Color.fromRGBO(22, 160, 133, 1),
      duration: 1100,
    );
  }
}
