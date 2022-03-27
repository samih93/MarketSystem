import 'package:get/get.dart';
import 'package:marketsystem/layout/market_layout.dart';

class MarketBinding extends Bindings {
  @override
  void dependencies() {
    //NOTE:  implement dependencies

    Get.put<MarketLayout>(MarketLayout(), permanent: true);
  }
}
