import 'package:flutter/material.dart';
import 'package:marketsystem/controllers/facture_controller.dart';
import 'package:marketsystem/models/facture.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:provider/provider.dart';

class ReceiptsScreen extends StatelessWidget {
  String? currentdate;
  ReceiptsScreen(this.currentdate);

  List<String> headertitles = ['Receipt number', 'Price', 'Details'];

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
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text(
                  '${currentdate}',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 30),
                ),
                Expanded(
                  child: SingleChildScrollView(
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
                            ...controller.list_of_receipts
                                .map((e) => _build_Row(e, context)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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
          TextButton(
              onPressed: () {},
              child: Text("details", style: TextStyle(color: Colors.blue)))
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
