import 'package:flutter/material.dart';
import 'package:marketsystem/controllers/facture_controller.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:provider/provider.dart';

class ReceiptsScreen extends StatelessWidget {
  String? currentdate;
  ReceiptsScreen({this.currentdate});

  //const ReceiptsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FactureController>(
        create: (_) => FactureController()..getReceiptsByDate(gettodayDate()),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Receipts"),
          ),
        ));
  }
}
