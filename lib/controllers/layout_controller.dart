import 'package:flutter/material.dart';
import 'package:marketsystem/screens/manage_products/manage_products.dart';
import 'package:marketsystem/screens/salesScreen/sales_screen.dart';
import 'package:marketsystem/screens/settings/settings_screen.dart';

class LayoutController extends ChangeNotifier {
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Products"),
    // BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Product"),
    BottomNavigationBarItem(
        icon: Icon(Icons.production_quantity_limits), label: "Sales"),
    // BottomNavigationBarItem(
    //     icon: Icon(Icons.store_mall_directory_outlined), label: "Settings"),
  ];

  //NOTE: ---------------------------Screens and Titles----------------------------
  final screens = [
    ManageProductsScreen(),
    SalesScreen(), /* SettingsScreen()*/
  ];

  final appbar_title = [
    'Manage Products',
    'Sales', /*'Settings'*/
  ];

  // NOTE: --------------------- On Change Index Of Screens ------------------

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void onchangeIndex(int index) {
    _currentIndex = index;
    _issearching_InProducts = false;

    notifyListeners();
  }

  //NOTE on change Search Status in products
  bool _issearching_InProducts = false;

  bool get issearchingInProducts => _issearching_InProducts;
  onChangeSearchInProductsStatus(bool val) {
    _issearching_InProducts = val;
    _currentIndex = 0;
    notifyListeners();
  }
}
