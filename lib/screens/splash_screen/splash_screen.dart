import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:marketsystem/controllers/auth_controller.dart';
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
  }

  Future _load_products() async {
    Future.delayed(Duration(seconds: 2)).then((value) async {
      await _loadUserData();
      await MarketDbHelper.db.init().then((value) async {
        await getDatabasesPath().then((value) async {
          print(value + "/Market.db");
          databasepath = value + "/Market.db";
          await Provider.of<ProductsController>(context, listen: false)
              .getAllProduct()
              .then((value) => Get.off(MarketLayout()));
        });
      });
    });
  }

  Future _loadUserData() async {
    await Provider.of<AuthController>(context, listen: false)
        .getUserData()
        .then((value) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MarketDbHelper>(
      create: (_) => MarketDbHelper.db,
      child: Container(
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
                    height: 10,
                  ),
                  Text(
                    "Market System",
                    style: TextStyle(
                        color: Colors.white, letterSpacing: 1, fontSize: 30),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  SpinKitWave(
                    color: Colors.white,
                    size: 35.0,
                  ),
                  Consumer<MarketDbHelper>(
                    builder: (BuildContext context, controller, Widget? child) {
                      if (controller.is_databaseExist == false)
                        return Text(
                          controller.progressDownload.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 1,
                              fontSize: 20),
                        );
                      return Container();
                    },
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
