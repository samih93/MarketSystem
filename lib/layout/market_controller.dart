import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/screens/add_product/add_product_screen.dart';
import 'package:marketsystem/screens/manage_products/manage_products.dart';
import 'package:marketsystem/screens/my%20store/my_store.dart';
import 'package:marketsystem/screens/sellScreen/sell_screen.dart';
import 'package:marketsystem/screens/settings/settings_screen.dart';
import 'package:marketsystem/shared/local/marketdb_helper.dart';
import 'package:marketsystem/shared/toast_message.dart';

class MarketController extends GetxController {
  MarketDbHelper marketdb = MarketDbHelper.db;
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    // getAllProduct().then((value) {
    //   //NOTE set products list in temp list
    //   _original_List_Of_product = _list_ofProduct;
    //   print("--------finishing Get products------");
    // });

    // getAllProductInStore().then((value) {
    //   _original_List_Of_product_in_store = _list_ofProduct_inStore;
    //   print("-----Finishing products In Store-------");
    // });

    //  deleteProductFromStore('5287001375015');
    super.onInit();
  }

  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Products"),
    // BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Product"),
    BottomNavigationBarItem(
        icon: Icon(Icons.production_quantity_limits), label: "Sell"),
    BottomNavigationBarItem(
        icon: Icon(Icons.store_mall_directory_outlined), label: "Settings"),
  ];

  //NOTE: ---------------------------Screens and Titles----------------------------
  final screens = [ManageProductsScreen(), SellScreen(), SettingsScreen()];

  final appbar_title = ['Manage Products', 'Sell Screen', 'Settings'];

  // NOTE: --------------------- On Change Index Of Screens ------------------

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void onchangeIndex(int index) {
    _currentIndex = index;
    _issearching_InProducts = false;

    update();
  }

  //NOTE on change Search Status in products
  bool _issearching_InProducts = false;

  bool get issearchingInProducts => _issearching_InProducts;
  onChangeSearchInProductsStatus(bool val) {
    _issearching_InProducts = val;
    //_currentIndex = 0;
    update();
  }

//NOTE search for item in products
  Future<void> search_In_Products(String value) async {
    isloadingGetProducts = true;
    update();
    _list_ofProduct = [];
    var dbm = await marketdb.database;

    await dbm
        .rawQuery("select * from products where name LIKE '%$value%'")
        .then((value) {
      value.forEach((element) {
        _list_ofProduct.add(ProductModel.fromJson(element));
      });

      isloadingGetProducts = false;
      update();
    });
  }

//NOTE search for a item in my store

  List<ProductModel> _list_of_product = [];
  Future<List<ProductModel>> autocomplete_Search_forProduct(
      String value) async {
    print('test');
    // isloadingGetProducts = true;
    update();
    _list_of_product = [];
    var dbm = await marketdb.database;

    await dbm
        .rawQuery("select * from products where name LIKE '%$value%'")
        .then((value) {
      value.forEach((element) {
        _list_of_product.add(ProductModel.fromJson(element));
      });

      //  isloadingGetProducts = false;
      update();
    });
    return _list_of_product;
  }

  clearSearch() {
    _list_ofProduct = _original_List_Of_product;
    _issearching_InProducts = false;
    update();
  }

  // NOTE get all
  List<ProductModel> _list_ofProduct = [];
  List<ProductModel> get list_ofProduct => _list_ofProduct;
  List<ProductModel> _original_List_Of_product = [];

  bool isloadingGetProducts = false;
  Future<void> getAllProduct() async {
    isloadingGetProducts = true;
    update();
    _list_ofProduct = [];
    var dbm = await marketdb.database;

    await dbm
        .rawQuery("select * from products order by name limit 200")
        .then((value) {
      value.forEach((element) {
        _list_ofProduct.add(ProductModel.fromJson(element));
      });

      isloadingGetProducts = false;
      update();
      _list_ofProduct.forEach((element) {
        print(element.toJson());
      });
    });
  }

//NOTE update product
  var statusUpdateBodyMessage = "";
  var statusUpdateMessage = ToastStatus.Error;
  Future<void> updateProduct(ProductModel model) async {
    var dbm = await marketdb.database;
    await dbm
        .rawUpdate(
            "UPDATE products SET barcode= '${model.barcode}', name= '${model.name}' , price= '${model.price}' where  barcode='${model.barcode}'")
        .then((value) async {
      ProductModel product = _list_ofProduct
          .where((element) => element.barcode == model.barcode)
          .first;
      if (!product.isBlank!) {
        // remove old one befor update
        _list_ofProduct.remove(product);
        //set new product object
        product.name = model.name;
        product.price = model.price;
        // add updated product to list
        _list_ofProduct.add(product);
        statusUpdateBodyMessage = " ${model.name} updated Successfully";
        statusUpdateMessage = ToastStatus.Success;
        update();
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  //NOTE fetch  product by barcode and then add to list of sell
  List<ProductModel> basket_products = [];

  Future<void> fetchProductBybarCode(String barcode) async {
    // isloadingGetProducts = true;
    var dbm = await marketdb.database;

    await dbm
        .rawQuery("select * from products where barcode = '$barcode'")
        .then((value) {
      value.forEach((element) {
        basket_products.add(ProductModel.fromJson(element));
      });
      basket_products.forEach((element) {
        element.qty = "1";
      });
      //  isloadingGetProducts = false;
      gettotalPrice();

      update();
    });
  }

  onchangeQtyInBasket(String barcode, String qty) {
    basket_products.forEach((element) {
      if (element.barcode == barcode) element.qty = qty;
    });
    update();
    basket_products.forEach((element) {
      print(element.qty);
    });
    gettotalPrice();
  }

  double totalprice = 0;
  gettotalPrice() {
    totalprice = 0;
    basket_products.forEach((element) {
      totalprice += int.parse(element.qty.toString()) *
          int.parse(element.price.toString());
    });
    update();
  }

  deleteProductFromBasket(String barcode) {
    ProductModel product =
        basket_products.where((element) => element.barcode == barcode).first;
    basket_products.remove(product);
    update();
    gettotalPrice();
  }

  clearBasket() {
    basket_products = [];
    totalprice = 0;
    update();
  }
}
