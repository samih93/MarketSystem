import 'package:flutter/material.dart';
import 'package:marketsystem/controllers/facture_controller.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:provider/provider.dart';

class ReceiptsScreen extends StatelessWidget {
  String? currentdate;
  ReceiptsScreen(this.currentdate);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FactureController>(
        create: (_) => FactureController()..getReceiptsByDate(currentdate!),
        child: Scaffold(
          appBar: AppBar(
            title: Text("Receipts"),
          ),
        ));
  }
}
