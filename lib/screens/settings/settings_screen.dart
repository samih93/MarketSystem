import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketsystem/api/pdf_api.dart';
import 'package:marketsystem/controllers/facture_controller.dart';
import 'package:marketsystem/models/details_facture.dart';
import 'package:marketsystem/shared/components/default_text_form.dart';
import 'package:marketsystem/shared/constant.dart';

import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SettingsScreen extends StatelessWidget {
  final List<String> _report_title = ["Report By Day", "Report by Month"];

  var datecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FactureController>(
      create: (_) => FactureController(),
      child: Scaffold(
        body: Consumer<FactureController>(
          builder: (context, facturecontroller, child) {
            return Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.04,
                  top: MediaQuery.of(context).size.width * 0.04),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: MediaQuery.of(context).size.width * 0.04, // horizontal
                runSpacing: 8, // vertical
                children: [
                  ..._report_title.map(
                    (element) => _report_item(
                      element,
                      _report_title.indexOf(element),
                      context,
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  _report_item(
    String title,
    int index,
    BuildContext context,
  ) =>
      GestureDetector(
        onTap: () async {
          switch (index) {
            case 0:
              Alert(
                  context: context,
                  title: "Enter Date",
                  content: Column(
                    children: <Widget>[
                      defaultTextFormField(
                          readonly: true,
                          controller: datecontroller,
                          inputtype: TextInputType.datetime,
                          prefixIcon: Icon(Icons.date_range),
                          ontap: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.parse('2022-01-01'),
                                    lastDate: DateTime.parse('2040-01-01'))
                                .then((value) {
                              //Todo: handle date to string
                              //print(DateFormat.yMMMd().format(value!));
                              var tdate = value.toString().split(' ');
                              datecontroller.text = tdate[0];
                            });
                          },
                          onvalidate: (value) {
                            if (value!.isEmpty) {
                              return "date must not be empty";
                            }
                          },
                          text: "date"),
                    ],
                  ),
                  buttons: [
                    DialogButton(
                      onPressed: () async {
                        print(datecontroller.text);
                        await context
                            .read<FactureController>()
                            .getReportByDate(datecontroller.text)
                            .then((value) {
                          print(value.length.toString());
                        });

                        // print(context
                        //     .read<FactureController>()
                        //     .list_of_detailsFacture[0]
                        //     .toJson());
                        //generate_reportByDay(reportData);

                        Navigator.pop(context);
                      },
                      child: Text(
                        "Ok",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ]).show();
              break;
            case 1:
              print('case 2 ');
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.44,
          height: MediaQuery.of(context).size.width * 0.44,
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
              Text(title),
            ],
          ),
        ),
      );

  Future<void> generate_reportByDay(List<DetailsFactureModel> list) async {
    final pdfFile = await PdfApi.generateTodayReport(list);
    PdfApi.openFile(pdfFile);
  }
}
