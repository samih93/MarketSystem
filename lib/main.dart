import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketsystem/controllers/layout_provider.dart';
import 'package:marketsystem/layout/market_controller.dart';
import 'package:marketsystem/layout/market_layout.dart';
import 'package:marketsystem/screens/splash_screen/splash_screen.dart';
import 'package:marketsystem/shared/local/marketdb_helper.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MarketDbHelper.db.init();
  Get.put(MarketController());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return LayoutController();
      },
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MarketLayout(),
      ),
    );
  }
}
