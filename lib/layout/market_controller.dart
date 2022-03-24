import 'package:get/get.dart';
import 'package:marketsystem/shared/local/marketdb_helper.dart';

class MarketController extends GetxController {
  MarketDbHelper db = MarketDbHelper.db;
  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    await db.createDatabase();
    super.onInit();
  }
}
