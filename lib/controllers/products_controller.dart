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

      _original_List_Of_product = _list_ofProduct;
      isloadingGetProducts = false;
      notifyListeners();
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
        // await updateProduct(model);
      } else {
        await dbm.insert("products", model.toJson());
        statusInsertBodyMessage = "product inserted successfully";
        statusInsertMessage = ToastStatus.Success;

        //NOTE Add new product to list
        _list_ofProduct.add(model);
      }
      print('inserted');
      notifyListeners();
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
        product.qty = model.qty;
        // add updated product to list
        _list_ofProduct.add(product);
        statusUpdateBodyMessage = " ${model.name} updated Successfully";
        statusUpdateMessage = ToastStatus.Success;
        _list_ofProduct.forEach((element) {
          print(element.toJson());
        });
        notifyListeners();
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

// NOTE Clear Search
  clearSearch() {
    _list_ofProduct = _original_List_Of_product;
    // _issearching_InProducts = false;
    notifyListeners();
  }

  //NOTE search for item in products
  Future<void> search_In_Products(String value) async {
    isloadingGetProducts = true;
    notifyListeners();
    _list_ofProduct = [];
    var dbm = await marketdb.database;

    await dbm
        .rawQuery("select * from products where name LIKE '%$value%'")
        .then((value) {
      value.forEach((element) {
        _list_ofProduct.add(ProductModel.fromJson(element));
      });

      isloadingGetProducts = false;
      notifyListeners();
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

      notifyListeners();
    });
  }

  onchangeQtyInBasket(String barcode, String qty) {
    basket_products.forEach((element) {
      if (element.barcode == barcode) element.qty = qty;
    });
    notifyListeners();
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
    notifyListeners();
  }

  deleteProductFromBasket(String barcode) {
    ProductModel product =
        basket_products.where((element) => element.barcode == barcode).first;
    basket_products.remove(product);
    notifyListeners();
    gettotalPrice();
  }

  clearBasket() {
    basket_products = [];
    totalprice = 0;
    notifyListeners();
  }
}
