import 'package:get/get.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/shared/local/marketdb_helper.dart';

class AddProductController extends GetxController {
  MarketDbHelper marketdb = MarketDbHelper.db;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit

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
}
