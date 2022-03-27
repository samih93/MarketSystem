import 'package:get/get.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/shared/local/marketdb_helper.dart';
import 'package:marketsystem/shared/toast_message.dart';

class AddProductController extends GetxController {
  MarketDbHelper marketdb = MarketDbHelper.db;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit

    super.onInit();
  }

  //NOTE insert Product

  var statusMessage = "".obs;
  var statusInsertMessage = ToastStatus.Error.obs;
  //  add evenstatusInsertMessaget by model
  Future<void> insertProductByModel({required ProductModel model}) async {
    var dbm = await marketdb.database;
    await marketdb.database
        .rawQuery("select * from products where barcode='${model.barcode}'")
        .then((value) async {
      if (value.length > 0) {
        statusMessage.value = "product Alreay Exist try Again ";
        statusInsertMessage.value = ToastStatus.Error;
      } else {
        await dbm.insert("products", model.toJson());
        statusMessage.value = "product inserted successfully";
        statusInsertMessage.value = ToastStatus.Success;
      }
      update();
    });
  }
}
