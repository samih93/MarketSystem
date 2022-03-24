import 'package:get/get.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/shared/local/marketdb_helper.dart';

class AddProductController extends GetxController {
  MarketDbHelper marketdb = MarketDbHelper.db;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit

    getAllProduct().then((value) {
      print("products-------------------");
    });
    super.onInit();
  }

  //NOTE insert Product

  //  add event by model
  Future<void> insertProductByModel({required ProductModel model}) async {
    var dbm = await marketdb.database;

    await dbm.insert("products", model.toJson());
    // await marketdb.database
    //     .rawQuery("select * from products where id='${id}'")
    //     .then((value) {
    //   value.forEach((element) {
    //     // update();
    //   });
    // });
  }

// NOTE get all
  List<ProductModel> _list_ofProduct = [];
  List<ProductModel> get list_ofProduct => _list_ofProduct;
  Future<void> getAllProduct() async {
    var dbm = await marketdb.database;

    await dbm.rawQuery("select * from products").then((value) {
      value.forEach((element) {
        print(element);
        //_list_ofProduct.add(ProductModel.fromJson(element));
      });

      _list_ofProduct.forEach((element) {
        print(element.toJson());
      });

      // print("N  " + _neweventListMap.length.toString());
      // print("D  " + _doneeventListMap.length.toString());
      // print("A  " + _archiveeventListMap.length.toString());
    }).then((value) {
      update();
    });
  }
}
