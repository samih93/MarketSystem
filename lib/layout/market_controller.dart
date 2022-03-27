import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/screens/add_product/add_product_screen.dart';
import 'package:marketsystem/screens/manage_products/manage_products.dart';
import 'package:marketsystem/screens/my%20store/my_store.dart';
import 'package:marketsystem/screens/saleScreen/sale_screen.dart';
import 'package:marketsystem/shared/local/marketdb_helper.dart';

class MarketController extends GetxController {
  MarketDbHelper marketdb = MarketDbHelper.db;
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    getAllProduct().then((value) {
      print("products-------------------");
    });
    super.onInit();
  }

  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Products"),
    BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Product"),
    BottomNavigationBarItem(
        icon: Icon(Icons.production_quantity_limits), label: "Sale"),
    BottomNavigationBarItem(
        icon: Icon(Icons.store_mall_directory_outlined), label: "My Store"),
  ];

  //NOTE: ---------------------------Screens and Titles----------------------------
  final screens = [
    ManageProductsScreen(),
    AddProductScreen(),
    SaleScreen(),
    MyStoreScreen()
  ];

  final appbar_title = [
    'Manage Products',
    'Add Product',
    'Sale Screen',
    'My Store'
  ];

  // NOTE: --------------------- On Change Index Of Screens ------------------

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void onchangeIndex(int index) {
    _currentIndex = index;
    update();
  }

  // NOTE get all
  List<ProductModel> _list_ofProduct = [];
  List<ProductModel> get list_ofProduct => _list_ofProduct;
  bool isloadingGetProducts = false;
  Future<void> getAllProduct() async {
    isloadingGetProducts = true;
    update();
    _list_ofProduct = [];
    var dbm = await marketdb.database;

    await dbm.rawQuery("select * from products order by name").then((value) {
      value.forEach((element) {
        print(element);
        _list_ofProduct.add(ProductModel.fromJson(element));
      });

      isloadingGetProducts = false;
      update();
      _list_ofProduct.forEach((element) {
        print(element.toJson());
      });
    });
  }

  //NOTE delete Product

  Future<void> deleteProduct(ProductModel model) async {
    var dbm = await marketdb.database;
    await dbm
        .rawDelete("DELETE FROM products where barcode='${model.barcode}'")
        .then((value) {
      print('value deleted :' + value.toString());
      ProductModel product = _list_ofProduct
          .where((element) => element.barcode == model.barcode)
          .first;
      //NOTE check if new event contain barcode
      if (!product.isBlank!) _list_ofProduct.remove(product);
      update();
    }).catchError((error) {
      print(error.toString());
    });
  }
}
