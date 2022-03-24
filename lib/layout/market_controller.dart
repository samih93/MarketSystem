import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketsystem/screens/add_product/add_product_screen.dart';
import 'package:marketsystem/screens/my_store/my_store_screen.dart';
import 'package:marketsystem/shared/local/marketdb_helper.dart';

class MarketController extends GetxController {
  MarketDbHelper db = MarketDbHelper.db;
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    await db.createDatabase();
    super.onInit();
  }

  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Product"),
    BottomNavigationBarItem(
        icon: Icon(Icons.store_outlined), label: "My Store"),
    BottomNavigationBarItem(
        icon: Icon(Icons.production_quantity_limits), label: "Sale"),
  ];

  //NOTE: ---------------------------Screens and Titles----------------------------
  final screens = [AddProductScreen(), MyStoreScreen(), SaleScreen()];

  final appbar_title = ['Add Product', 'My Store', 'Sale Screen'];

  // NOTE: --------------------- On Change Index Of Screens ------------------

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void onchangeIndex(int index) {
    _currentIndex = index;
    update();
  }
}
