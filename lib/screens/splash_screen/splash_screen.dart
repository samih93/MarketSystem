import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:marketsystem/controllers/products_controller.dart';
import 'package:marketsystem/layout/market_layout.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:marketsystem/shared/local/marketdb_helper.dart';
import 'package:marketsystem/shared/styles.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

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
    await MarketDbHelper.db.init().then((value) async {
      await getDatabasesPath().then((value) async {
        print(value + "/Market.db");
        databasepath = value + "/Market.db";
        await Provider.of<ProductsController>(context, listen: false)
            .getAllProduct()
            .then((value) => Get.off(MarketLayout()));
      });
    });

    // Future.delayed(Duration(seconds: 1)).then((value) async {

    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: myLinearGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: const Image(
                      image: AssetImage("assets/splash_screen.png")),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  "Market System",
                  style: TextStyle(color: Colors.white, letterSpacing: 1),
                ),
              ],
            )),
      ),
    );
  }
}
