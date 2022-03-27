import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketsystem/layout/market_controller.dart';
import 'package:marketsystem/layout/market_layout.dart';
import 'package:marketsystem/models/product.dart';

class ManageProductsScreen extends StatelessWidget {
  List<String> headertitles = ['BarCode', 'Name', 'Price', 'Edit'];

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
                  child: DataTable(
                    columns: [
                      ...headertitles.map((e) => _build_header_item(e))
                    ],
                    rows: [
                      ...marketController.list_ofProduct
                          .map((e) => _build_Row(e, marketController)),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  _build_header_item(String headerTitle) => DataColumn(
      label: Text(headerTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )));

  _build_Row(ProductModel model, MarketController _controller) =>
      DataRow(cells: [
        DataCell(Text(model.barcode.toString())),
        DataCell(Text(model.name.toString())),
        DataCell(Text(model.price.toString())),
        DataCell(Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.edit,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () {
                _controller.deleteProduct(model);
              },
              icon: Icon(
                Icons.delete,
              ),
            ),
          ],
        )),
      ]);
}
