import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketsystem/layout/market_controller.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/screens/add_product_to_my_Store/add_product_to_store_screen.dart';
import 'package:marketsystem/shared/constant.dart';

class MyStoreScreen extends StatelessWidget {
  List<String> headertitles = ['Name', 'BarCode', 'Qty'];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketController>(
        init: Get.find<MarketController>(),
        builder: (marketController) => Scaffold(
              body: marketController.isloadingGetProducts
                  ? Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: DataTable(
                            headingTextStyle: TextStyle(color: defaultColor),
                            border:
                                TableBorder.all(width: 1, color: Colors.grey),
                            columns: [
                              ...headertitles.map((e) => _build_header_item(e))
                            ],
                            rows: [
                              ...marketController.list_ofProduct.map(
                                  (e) =>
                                      _build_Row(e, marketController, context)),
                            ],
                          ),
                        ),
                      ),
                    ),
              floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: () {
                    Get.to(AddProductToMyStoreScreen());
                  }),
            ));
  }

  _build_header_item(String headerTitle) => DataColumn(
      label: Text(headerTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )));

  _build_Row(ProductModel model, MarketController _controller,
          BuildContext context) =>
      DataRow(cells: [
        DataCell(Text(model.name.toString())),
        DataCell(Text(model.barcode.toString())),
        DataCell(Text(model.qty.toString())),
      ]);
}
