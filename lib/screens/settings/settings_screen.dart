import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketsystem/api/pdf_api.dart';
import 'package:marketsystem/controllers/facture_controller.dart';
import 'package:marketsystem/models/details_facture.dart';
import 'package:marketsystem/shared/components/default_text_form.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:marketsystem/shared/styles.dart';
import 'package:marketsystem/shared/toast_message.dart';

import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SettingsScreen extends StatelessWidget {
  final List<String> _report_title = [
    "Report By Day",
    "Report Between Two Dates",
    "Best Selling",
    "Most profitable Products"
  ];

  final List<IconData> _report_icons = [
    Icons.report,
    Icons.report,
    Icons.loyalty_sharp,
    Icons.turn_sharp_right_outlined
  ];

  var datecontroller = TextEditingController();
  var startdatecontroller = TextEditingController();
  var enddatecontroller = TextEditingController();
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
                      _report_icons[_report_title.indexOf(element)],
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
    IconData icon,
    int index,
    BuildContext context,
  ) =>
      GestureDetector(
        onTap: () async {
          switch (index) {
            case 0:
              datecontroller.clear();

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
                          _openReportByDateOrBetween(
                              value, datecontroller.text.toString());
                        });

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
              startdatecontroller.clear();
              enddatecontroller.clear();
              Alert(
                  context: context,
                  title: "Enter Dates",
                  content: Column(
                    children: <Widget>[
                      defaultTextFormField(
                          readonly: true,
                          controller: startdatecontroller,
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
                              startdatecontroller.text = tdate[0];
                            });
                          },
                          onvalidate: (value) {
                            if (value!.isEmpty) {
                              return "start date must not be empty";
                            }
                          },
                          text: "start date"),
                      SizedBox(
                        height: 10,
                      ),
                      defaultTextFormField(
                          readonly: true,
                          controller: enddatecontroller,
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
                              enddatecontroller.text = tdate[0];
                            });
                          },
                          onvalidate: (value) {
                            if (value!.isEmpty) {
                              return "end date must not be empty";
                            }
                          },
                          text: "end date"),
                    ],
                  ),
                  buttons: [
                    DialogButton(
                      onPressed: () async {
                        print(datecontroller.text);
                        await context
                            .read<FactureController>()
                            .getDetailsFacturesBetweenTwoDates(
                                startdatecontroller.text,
                                enddatecontroller.text)
                            .then((value) {
                          print(value.length.toString());
                          _openReportByDateOrBetween(
                              value, startdatecontroller.text.toString(),
                              enddate: enddatecontroller.text);
                        });

                        Navigator.pop(context);
                      },
                      child: Text(
                        "Ok",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ]).show();
              break;
            case 2:
              await context
                  .read<FactureController>()
                  .getBestSelling()
                  .then((value) {
                _openBestSellingReport(value);
              });

              break;

            case 3:
              showToast(
                  message: "Under developing", status: ToastStatus.Warning);
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width * 0.44,
          height: MediaQuery.of(context).size.width * 0.44,
          decoration: BoxDecoration(
              gradient: myLinearGradient,
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 60, color: Colors.white),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      );

  Future<void> _openReportByDateOrBetween(
      List<DetailsFactureModel> list, String startDate,
      {String? enddate}) async {
    final pdfFile = await PdfApi.generateReport(list,
        startDate: startDate, endDate: enddate);
    PdfApi.openFile(pdfFile);
  }

  Future<void> _openBestSellingReport(List<DetailsFactureModel> list) async {
    final pdfFile = await PdfApi.generateBestSellingReport(list);
    PdfApi.openFile(pdfFile);
  }
}
