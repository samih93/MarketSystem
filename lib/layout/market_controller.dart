import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/screens/add_product/add_product_screen.dart';
import 'package:marketsystem/screens/manage_products/manage_products.dart';
import 'package:marketsystem/screens/my%20store/my_store.dart';
import 'package:marketsystem/screens/saleScreen/sale_screen.dart';
import 'package:marketsystem/shared/local/marketdb_helper.dart';
import 'package:marketsystem/shared/toast_message.dart';

class MarketController extends GetxController {
  MarketDbHelper marketdb = MarketDbHelper.db;
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    getAllProduct().then((value) {
      //NOTE set products list in temp list
      _original_List_Of_product = _list_ofProduct;
      print("products-------------------");
    });
    super.onInit();
  }

  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "Products"),
    // BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Product"),
    BottomNavigationBarItem(
        icon: Icon(Icons.production_quantity_limits), label: "Sale"),
    BottomNavigationBarItem(
        icon: Icon(Icons.store_mall_directory_outlined), label: "My Store"),
  ];

  //NOTE: ---------------------------Screens and Titles----------------------------
  final screens = [
    ManageProductsScreen(),
    // AddProductScreen(),
    SaleScreen(),
    MyStoreScreen()
  ];

  final appbar_title = [
    'Manage Products',
    // 'Add Product',
    'Sale Screen',
    'My Store'
  ];

  // NOTE: --------------------- On Change Index Of Screens ------------------

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void onchangeIndex(int index) {
    _currentIndex = index;
    if (index == 1) {
      _issearching_InProducts = false;
      _issearching_InStore = false;
    }
    update();
  }

  //NOTE on change Search Status in products
  bool _issearching_InProducts = false;

  bool get issearchingInProducts => _issearching_InProducts;
  onChangeSearchInProductsStatus(bool val) {
    _issearching_InProducts = val;
    _issearching_InStore = false;
    _currentIndex = 0;
    update();
  }

  //NOTE on change Search Status in products
  bool _issearching_InStore = false;

  bool get issearchingInStore => _issearching_InStore;
  onChangeSearchInStoreStatus(bool val) {
    _issearching_InStore = val;
    _issearching_InProducts = false;
    _currentIndex = 2;
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
  Future<List<ProductModel>> search_In_Store(String value) async {
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
    return _list_ofProduct;
  }

  clearSearch() {
    _list_ofProduct = _original_List_Of_product;
    _issearching_InProducts = false;
    _issearching_InStore = false;
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

  //NOTE insert Product

  var statusInsertBodyMessage = "".obs;
  var statusInsertMessage = ToastStatus.Error.obs;
  //  add evenstatusInsertMessaget by model
  Future<void> insertProductByModel({required ProductModel model}) async {
    var dbm = await marketdb.database;
    await marketdb.database
        .rawQuery("select * from products where barcode='${model.barcode}'")
        .then((value) async {
      if (value.length > 0) {
        statusInsertBodyMessage.value = "product Alreay Exist try Again ";
        statusInsertMessage.value = ToastStatus.Error;
      } else {
        await dbm.insert("products", model.toJson());
        statusInsertBodyMessage.value = "product inserted successfully";
        statusInsertMessage.value = ToastStatus.Success;

        //NOTE Add new product to list
        _list_ofProduct.add(model);
      }
      update();
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

//NOTE update product
  var statusUpdateBodyMessage = "";
  var statusUpdateMessage = ToastStatus.Error;
  Future<void> updateProduct(ProductModel model) async {
    var dbm = await marketdb.database;
    await dbm
        .rawUpdate(
            "UPDATE products SET barcode= '${model.barcode}', name= '${model.name}' , price= '${model.price}' where  barcode='${model.barcode}'")
        .then((value) async {
      // NOTE if current index ==0 i have two option done or archive
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
}
