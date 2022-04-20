import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketsystem/controllers/products_controller.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/screens/add_product/add_product_screen.dart';
import 'package:marketsystem/screens/edit_product/edit_product.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ManageProductsScreen extends StatelessWidget {
  List<String> headertitles = [
    'Name',
    'BarCode',
    'Price per item',
    'Qty',
    'Edit'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ProductsController>(builder: (context, controller, child) {
        print('manageScreen');
        return controller.isloadingGetProducts
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: DataTable(
                      headingTextStyle: TextStyle(color: defaultColor),
                      border: TableBorder.all(width: 1, color: Colors.grey),
                      columns: [
                        ...headertitles.map((e) => _build_header_item(e))
                      ],
                      rows: [
                        ...controller.list_ofProduct
                            .map((e) => _build_Row(e, context)),
                      ],
                    ),
                  ),
                ),
              );
      }),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Get.to(AddProductScreen());
          }),
    );
  }

  _build_header_item(String headerTitle) => DataColumn(
      label: Text(headerTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )));

  _build_Row(ProductModel model, BuildContext context) => DataRow(cells: [
        DataCell(Text(model.name.toString())),
        DataCell(Text(model.barcode.toString())),
        DataCell(Text(model.price.toString())),
        DataCell(Text(model.qty.toString())),
        DataCell(Row(
          children: [
            IconButton(
              onPressed: () {
                Get.to(() => EditProductScreen(model: model));
              },
              icon: Icon(
                Icons.edit,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            IconButton(
              onPressed: () {
                var alertStyle =
                    AlertStyle(animationDuration: Duration(milliseconds: 1));
                Alert(
                  style: alertStyle,
                  context: context,
                  type: AlertType.error,
                  title: "Delete Item",
                  desc: "Are You Sure You Want To Delete '${model.name}'",
                  buttons: [
                    DialogButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.blue.shade400,
                    ),
                    DialogButton(
                      child: Text(
                        "Delete",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      onPressed: () {
                        Provider.of<ProductsController>(context, listen: false)
                            .deleteProduct(model);
                        Get.back();
                      },
                      color: Colors.red.shade400,
                    ),
                  ],
                ).show();
              },
              icon: Icon(
                Icons.delete,
              ),
            ),
          ],
        )),
      ]);
}
