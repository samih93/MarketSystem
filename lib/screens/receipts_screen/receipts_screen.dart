import 'package:flutter/material.dart';
import 'package:marketsystem/controllers/facture_controller.dart';
import 'package:marketsystem/models/facture.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:provider/provider.dart';

class ReceiptsScreen extends StatelessWidget {
  String? currentdate;
  ReceiptsScreen(this.currentdate);

  List<String> headertitles = ['Facture number', 'Price', 'Details'];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FactureController>(
        create: (_) => FactureController()..getReceiptsByDate(currentdate!),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Receipts"),
          ),
          body: Consumer<FactureController>(
              builder: (context, controller, child) {
            return DataTable(
              headingTextStyle: TextStyle(color: defaultColor),
              border: TableBorder.all(width: 1, color: Colors.grey),
              columns: [...headertitles.map((e) => _build_header_item(e))],
              rows: [
                ...controller.list_of_receipts
                    .map((e) => _build_Row(e, context)),
              ],
            );
          }),
        ));
  }

  _build_Row(FactureModel model, BuildContext context) {
    return DataRow(cells: [
      DataCell(Text(model.id.toString())),
      DataCell(Text(model.price.toString())),
      DataCell(Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.details,
            ),
          ),
        ],
      )),
    ]);
  }

  _build_header_item(String headerTitle) => DataColumn(
      label: Text(headerTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )));
}
