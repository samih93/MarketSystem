import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/shared/local/marketdb_helper.dart';
import 'package:marketsystem/shared/toast_message.dart';

class ProductsController extends ChangeNotifier {
  MarketDbHelper marketdb = MarketDbHelper.db;

  // NOTE get all
  List<ProductModel> _list_ofProduct = [];
  List<ProductModel> get list_ofProduct => _list_ofProduct;
  List<ProductModel> _original_List_Of_product = [];

  bool isloadingGetProducts = false;
  Future<void> getAllProduct() async {
    isloadingGetProducts = true;
    notifyListeners();
    _list_ofProduct = [];
    var dbm = await marketdb.database;

    await dbm
        .rawQuery("select * from products order by name limit 200")
        .then((value) {
      value.forEach((element) {
        _list_ofProduct.add(ProductModel.fromJson(element));
      });

      isloadingGetProducts = false;
      notifyListeners();
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
      //NOTE check if new product contain barcode
      if (!product.isBlank!) _list_ofProduct.remove(product);
      notifyListeners();
    }).catchError((error) {
      print(error.toString());
    });
  }

  //NOTE insert new Product

  var statusInsertBodyMessage = "";
  var statusInsertMessage = ToastStatus.Error;
  //  add evenstatusInsertMessaget by model
  Future<void> insertProductByModel({required ProductModel model}) async {
    var dbm = await marketdb.database;
    await marketdb.database
        .rawQuery("select * from products where barcode='${model.barcode}'")
        .then((value) async {
      if (value.length > 0) {
        statusInsertBodyMessage = "product Alreay Exist try Again ";
        // !  need to update
        statusInsertMessage = ToastStatus.Error;
      } else {
        await dbm.insert("products", model.toJson());
        statusInsertBodyMessage = "product inserted successfully";
        statusInsertMessage = ToastStatus.Success;

        //NOTE Add new product to list
        _list_ofProduct.add(model);
      }
      notifyListeners();
    });
  }
}
