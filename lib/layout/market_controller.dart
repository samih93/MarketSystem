import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/screens/add_product/add_product_screen.dart';
import 'package:marketsystem/screens/manage_products/manage_products.dart';
import 'package:marketsystem/screens/sellScreen/sell_screen.dart';
import 'package:marketsystem/screens/settings/settings_screen.dart';
import 'package:marketsystem/shared/local/marketdb_helper.dart';
import 'package:marketsystem/shared/toast_message.dart';

class MarketController extends GetxController {
  MarketDbHelper marketdb = MarketDbHelper.db;
  @override

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
}
