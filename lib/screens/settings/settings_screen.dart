import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketsystem/api/pdf_api.dart';
import 'package:marketsystem/controllers/facture_controller.dart';
import 'package:marketsystem/models/details_facture.dart';
import 'package:marketsystem/screens/reports/today_report.dart';
import 'package:marketsystem/shared/constant.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FactureController>(
      create: (_) => FactureController()..getTodayReport(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<FactureController>(
            builder: (context, facturecontroller, child) {
              return _report_item(
                  context, facturecontroller.list_of_detailsFacture);
            },
          ),
        ),
      ),
    );
  }

  _report_item(BuildContext context, List<DetailsFactureModel> list) =>
      GestureDetector(
        onTap: () async {
          //Get.to(TodayReportScreen());
          final pdfFile = await PdfApi.generateTodayReport(list);
          PdfApi.openFile(pdfFile);
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.45,
          height: MediaQuery.of(context).size.width * 0.45,
          color: defaultColor.shade300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.report,
                size: 60,
              ),
              SizedBox(
                height: 10,
              ),
              Text("Today Report"),
            ],
          ),
        ),
      );
}
