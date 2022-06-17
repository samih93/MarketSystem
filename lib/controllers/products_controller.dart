import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:marketsystem/models/details_facture.dart';
import 'package:marketsystem/models/facture.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:marketsystem/shared/local/marketdb_helper.dart';
import 'package:marketsystem/shared/toast_message.dart';

class ProductsController extends ChangeNotifier {
  MarketDbHelper marketdb = MarketDbHelper.db;

  // NOTE get all
  List<ProductModel> _list_ofProduct = [];
  List<ProductModel> get list_ofProduct => _list_ofProduct;
  List<ProductModel> _original_List_Of_product = [];

  bool isloadingGetProducts = false;

  Future<List<ProductModel>> getAllProduct() async {
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

      _list_ofProduct.forEach((element) {
        print(element.toJson());
      });

      _original_List_Of_product = _list_ofProduct;
      isloadingGetProducts = false;
      notifyListeners();
    });
    return _list_ofProduct;
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
        ProductModel productModel = ProductModel.fromJson(value[0]);
        int newqty = int.parse(model.qty.toString()) +
            int.parse(productModel.qty.toString());

        print("total price " + productModel.totalprice.toString());
        int totalprice = int.parse(model.totalprice.toString().trim()) == ""
            ? 0
            : int.parse(model.totalprice.toString()) +
                int.parse(productModel.totalprice.toString());
        productModel.qty = newqty.toString();
        productModel.price = model.price;
        productModel.totalprice = totalprice.toString();
        productModel.profit_per_item = productModel.profit_per_item;
        //profit depends on new data
        // productModel.profit_per_item = (((int.parse(model.qty.toString()) *
        //                 int.parse(model.price.toString())) -
        //             int.parse(model.totalprice.toString())) /
        //         int.parse(model.qty.toString()))
        //     .toString();
        print('updated');

        await updateProduct(productModel).then((value) {
          statusInsertBodyMessage = " ${model.name} updated Successfully";
          statusInsertMessage = ToastStatus.Success;
        });

        //   statusInsertBodyMessage = "product Alreay Exist try Again ";
        // !  need to update
        // statusInsertMessage = ToastStatus.Error;
        // await updateProduct(model);
      } else {
        await dbm.insert("products", model.toJson());
        statusInsertBodyMessage = "product inserted successfully";
        statusInsertMessage = ToastStatus.Success;

        //NOTE Add new product to list
        _list_ofProduct.add(model);
        print('inserted');
      }
      //isProductExist = false;
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
            "UPDATE products SET barcode= '${model.barcode}', name= '${model.name}' , price= '${model.price}', qty='${model.qty}' , totalprice='${model.totalprice}' ,profit_per_item='${model.profit_per_item}' where  barcode='${model.barcode}'")
        .then((value) async {
      statusUpdateBodyMessage = " ${model.name} updated Successfully";
      statusUpdateMessage = ToastStatus.Success;
      // ! remove and add the new product in productList
      _updateProductInUI(model);
    }).catchError((error) {
      print(error.toString());
    });
  }

// NOTE fetch item by barcode and the update it
  _updateProductInUI(ProductModel model) {
    _list_ofProduct.forEach((element) {
      if (element.barcode == model.barcode) {
        element.name = model.name;
        element.price = model.price;
        element.qty = model.qty;
        element.profit_per_item = model.profit_per_item;
      }
    });
    notifyListeners();

// ! this is for check in list for a item wihtout loop in all list
    // ProductModel product = _list_ofProduct
    //     .where((element) => element.barcode == model.barcode)
    //     .first;
    // if (!product.isBlank!) {
    //   // remove old one befor update
    //   _list_ofProduct.remove(product);
    //   //set new product object
    //   product.name = model.name;
    //   product.price = model.price;
    //   product.qty = model.qty;
    //   // add updated product to list
    //   _list_ofProduct.add(product);
    // }
    //!------------------------------------------------
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

  Future<bool> fetchProductBybarCode(String barcode) async {
    // isloadingGetProducts = true;
    var dbm = await marketdb.database;
    bool _isExist = false;

    await dbm
        .rawQuery("select * from products where barcode = '$barcode'")
        .then((value) {
      if (value.length > 0) {
        _isExist = true;
        value.forEach((element) {
          basket_products.add(ProductModel.fromJson(element));
        });
      } else {
        _isExist = false;
      }

      basket_products.forEach((element) {
        if (element.barcode == barcode) element.qty = "1";
      });
      //  isloadingGetProducts = false;
      gettotalPrice();

      notifyListeners();
    });
    return _isExist;
  }

// when
  void setisproductExistTofalse() {}

//NOTE get Product by barcode

  bool isProductExist = false;
  Future<ProductModel?> getProductbyBarcode(String barcode) async {
    var dbm = await marketdb.database;
    ProductModel? model;

    await dbm
        .rawQuery("select * from products where barcode = '$barcode'")
        .then((value) {
      print("product lenght " + value.length.toString());
      if (value.length > 0) {
        isProductExist = true;
        value.forEach((element) {
          model = ProductModel.fromJson(element);
        });
      } else {
        isProductExist = false;
      }
      print("is product exist in provider " + isProductExist.toString());
      notifyListeners();
    });
    return model;
  }

// NOTE on change qty in sell screen

  Future<bool> onchangeQtyInBasket(String barcode, String qty) async {
    bool isonchangesuccess = true;
    ProductModel? model = await getProductbyBarcode(barcode);
    if (int.parse(model!.qty.toString()) >= int.parse(qty)) {
      basket_products.forEach((element) {
        if (element.barcode == barcode) element.qty = qty;
      });
      notifyListeners();
      basket_products.forEach((element) {
        print(element.qty);
      });
      isonchangesuccess = true;
    } else {
      basket_products.forEach((element) {
        if (element.barcode == barcode) element.qty = model.qty;
      });
      isonchangesuccess = false;
    }
    gettotalPrice();

    return isonchangesuccess;
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

  Future<void> addFacture() async {
    int facture_id = 0;
    var dbm = await marketdb.database;

    //NOTE first add a facture to table facture and get insert id
    FactureModel factureModel =
        FactureModel(price: totalprice.toString(), facturedate: gettodayDate());

    facture_id = await dbm.insert("factures", factureModel.toJson());
    print('facture inserted $facture_id');

    basket_products.forEach((element) async {
      int totalprice = (int.parse(element.qty.toString().trim()) *
          int.parse(element.price.toString()));
      DetailsFactureModel detailsFactureModel = DetailsFactureModel(
          barcode: element.barcode,
          name: element.name,
          qty: element.qty,
          price: totalprice.toString(),
          facture_id: facture_id,
          profit_per_item_on_sale: element.profit_per_item);
      print(detailsFactureModel.toJson());

      ProductModel? productModel =
          await getProductbyBarcode(element.barcode.toString());
      // when i enter  next time without fetch to make field is enabled
      isProductExist = false;
      notifyListeners();
      int newqty = 0;
      if (productModel != null)
        newqty = int.parse(productModel.qty.toString()) -
            int.parse(element.qty.toString());

// NOTE  updated each product in my store depend on basket items
      await dbm.rawUpdate("update products set qty=? where barcode=?",
          ['$newqty', '${element.barcode}']).then((value) async {
        // NOTE update items in my current list of products without getting data again from database
        productModel!.qty = newqty.toString();
        _updateProductInUI(productModel);
        await dbm
            .insert('detailsfacture', detailsFactureModel.toJson())
            .then((value) {
          print('details facture inserted');
          clearBasket();
        });
      });
    });
  }

  //NOTE auto complete search for a product
  Future<List<ProductModel>> autocomplete_Search_forProduct(
      String value) async {
    List<ProductModel> list_ofProduct = [];
    var dbm = await marketdb.database;

    await dbm
        .rawQuery("select * from products where name LIKE '%$value%'")
        .then((value) {
      value.forEach((element) {
        list_ofProduct.add(ProductModel.fromJson(element));
      });
    });
    return list_ofProduct;
  }

  Future<void> cleanDatabase() async {
    var dbm = await marketdb.database;
    await dbm.rawDelete("DELETE FROM products").then((value) {
      _list_ofProduct = [];
      notifyListeners();
    });
    await dbm.rawDelete("DELETE FROM factures");
    await dbm.rawDelete("DELETE FROM detailsfacture");
  }
}
