import 'dart:async';
import 'package:flutter/material.dart';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:lottie/lottie.dart';

import 'IntroPage.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Lottie.asset(
        'assets/Lottie/Animation.json',
        // Replace with your Lottie animation file
        width: 200,
        height: 200,
      ),
      nextScreen: IntroPage(),
      splashTransition: SplashTransition.fadeTransition,
      duration: 3000,
    );
  }
}
