import 'package:flutter/material.dart';
import 'package:marketsystem/controllers/facture_controller.dart';
import 'package:marketsystem/models/details_facture.dart';
import 'package:marketsystem/models/facture.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:marketsystem/shared/styles.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class ReceiptsScreen extends StatelessWidget {
  String? currentdate;
  ReceiptsScreen(this.currentdate);

  List<String> headertitles = ['Receipt Nb', 'Price', 'Details'];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FactureController>(
        create: (_) => FactureController()..getReceiptsByDate(currentdate!),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Receipts"),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: myLinearGradient,
              ),
            ),
          ),
          body: Consumer<FactureController>(
              builder: (context, controller, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: Colors.grey.shade600,
                  height: 60,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${currentdate}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 2,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                controller.list_of_receipts.length > 0
                    ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: DataTable(
                            headingTextStyle: TextStyle(color: defaultColor),
                            border:
                                TableBorder.all(width: 1, color: Colors.grey),
                            columns: [
                              ...headertitles.map((e) => _build_header_item(e))
                            ],
                            rows: [
                              ...controller.list_of_receipts
                                  .map((e) => _build_Row(e, context)),
                            ],
                          ),
                        ),
                      )
                    : Expanded(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("No Receipts yet",
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 25)),
                        ],
                      ))
              ],
            );
          }),
        ));
  }

  _build_Row(FactureModel model, BuildContext context) {
    return DataRow(cells: [
      DataCell(Center(child: Text('#1-${model.id.toString()}'))),
      DataCell(Text(model.price.toString())),
      DataCell(Row(
        children: [
          TextButton(
              onPressed: () async {
                await context.read<FactureController>()
                  ..getDetailsFacturesBetweenTwoDates(
                          currentdate!, currentdate!,
                          receiptId: model.id.toString())
                      .then((value) {
                    var alertStyle = AlertStyle(
                        animationDuration: Duration(milliseconds: 1));
                    Alert(
                            style: alertStyle,
                            title: "Items",
                            content: Container(
                              height: 200,
                              width: 300,
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _buildheaderDialog(),
                                    Divider(
                                      color: defaultColor,
                                    ),
                                    ...value.map(
                                        (e) => _builddetailsfacture_item(e)),
                                    _buildResult(model.price.toString()),
                                  ],
                                ),
                              ),
                            ),
                            context: context)
                        .show();
                  }).catchError((error) {
                    print('error');
                  });
              },
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

  _builddetailsfacture_item(DetailsFactureModel model) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 2,
                child: Text(
                  model.name.toString(),
                  style: TextStyle(fontSize: 12),
                )),
            Expanded(
                flex: 1,
                child: Text(
                  model.qty.toString(),
                  style: TextStyle(fontSize: 12),
                )),
            Expanded(
                flex: 1,
                child: Text(
                  '${double.parse(model.price.toString()) * double.parse(model.qty.toString())}',
                  style: TextStyle(fontSize: 12),
                )),
          ],
        ),
        Divider(),
      ],
    );
  }

  _buildheaderDialog() {
    return Row(children: [
      Expanded(
          flex: 2,
          child: Text(
            'Name',
            style: TextStyle(fontSize: 12),
          )),
      Expanded(
          flex: 1,
          child: Text(
            'Qty',
            style: TextStyle(fontSize: 12),
          )),
      Expanded(
          flex: 1,
          child: Text(
            'Price',
            style: TextStyle(fontSize: 12),
          ))
    ]);
  }

  _buildResult(String price) {
    return Row(
      children: [
        Expanded(child: Container(), flex: 1),
        Expanded(child: Container(), flex: 1),
        Expanded(
            child: Text(
              price,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            flex: 1),
      ],
    );
  }
}
