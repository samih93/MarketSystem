import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:marketsystem/controllers/products_controller.dart';
import 'package:marketsystem/layout/market_layout.dart';
import 'package:marketsystem/shared/styles.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    SchedulerBinding.instance!.addPostFrameCallback((_) {
      _load_products().then((value) {
        print('getting products');
      });
    });
    super.initState();
  }

  Future _load_products() async {
    await Provider.of<ProductsController>(context, listen: false)
        .getAllProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: myLinearGradient),
      child: AnimatedSplashScreen(
        duration: 2000,
        splash: 'assets/splash_screen.png',
        nextScreen: MarketLayout(),
        splashTransition: SplashTransition.fadeTransition,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
