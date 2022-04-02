import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:marketsystem/layout/market_layout.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 2000,
      splash: 'assets/splash_screen.png',
      nextScreen: MarketLayout(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.green.shade200,
    );
  }
}
