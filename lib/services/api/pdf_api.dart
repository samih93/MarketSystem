import 'dart:io';

import 'package:flutter/services.dart';
import 'package:marketsystem/models/details_facture.dart';
import 'package:marketsystem/models/viewmodel/best_selling.dart';
import 'package:marketsystem/models/viewmodel/earn_spent_vmodel.dart';
import 'package:marketsystem/models/viewmodel/low_qty_model.dart';
import 'package:marketsystem/models/viewmodel/profitable_vmodel.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfApi {
  static Future<File> generateCenteredText(String text) async {
    final pdf = Document();

    pdf.addPage(Page(
      build: (context) => Center(
        child:
            Text(text, style: TextStyle(fontSize: 48, color: PdfColors.pink)),
      ),
    ));

    return saveDocument(name: 'my_example.pdf', doc: pdf);
  }

// startdate!=null && endDate==null ==> report by date
// startdate!=null && endDate!=null ==> report between two dates
// startdate==null && endDate==null ==> generate report Best Selling
  static Future<File> generateReport(List<DetailsFactureModel> list,
      {String? startDate, String? endDate}) async {
    double finalprice = 0;
    list.forEach((element) {
      finalprice += double.parse(element.totalprice.toString());
    });
    final pdf = Document();

    final customfont =
        Font.ttf(await rootBundle.load("assets/Hacen Tunisia.ttf"));

    // String today = gettodayDate();
    pdf.addPage(MultiPage(
        build: (context) => <Widget>[
              _build_header(startdate: startDate, enddate: endDate),
              SizedBox(height: 10),
              Table(
                tableWidth: TableWidth.max,
                //defaultColumnWidth: FixedColumnWidth(120.0),
                //defaultColumnWidth: FixedColumnWidth(screenWidth(_)*.3),

                border: TableBorder.all(
                    color: PdfColors.grey, style: BorderStyle.solid, width: 1),
                children: [
                  TableRow(children: [
                    Column(children: [
                      Text('Product Name',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold))
                    ]),
                    Column(children: [
                      Text('Qty',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold))
                    ]),
                    Column(children: [
                      Text('Price',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold))
                    ]),
                    Column(children: [
                      Text('total',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold))
                    ]),
                  ]),
                  ...list.map((e) => TableRow(children: [
                        Column(
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                  e.name.toString().length > 20
                                      ? "${e.name.toString().substring(0, 20)}..."
                                      : e.name.toString(),
                                  style: TextStyle(
                                      font: customfont, fontSize: 20)),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(e.qty.toString(),
                                  style: TextStyle(
                                      font: customfont, fontSize: 20)),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(e.price.toString(),
                                  style: TextStyle(
                                      font: customfont, fontSize: 20)),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(e.totalprice.toString(),
                                  style: TextStyle(
                                      font: customfont, fontSize: 20)),
                            ),
                          ],
                        ),
                      ]))
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Total  : ",
                    style: TextStyle(color: PdfColors.red, fontSize: 30),
                  ),
                  SizedBox(width: 5),
                  Text("${finalprice} LL",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                ],
              ),
              SizedBox(height: 20),
            ],
        footer: (context) => Container(
            alignment: Alignment.bottomRight,
            child:
                Text("Page ${context.pageNumber} of ${context.pagesCount}"))));
    return saveDocument(
        name: startDate != null && endDate != null
            ? 'Report from $startDate to $endDate'
            : startDate != null && endDate == null
                ? 'Report_${startDate}.pdf'
                : "Best Selling Report",
        doc: pdf);
  }

  static Future<File> generateBestSellingReport(
    List<BestSellingVmodel> list,
  ) async {
    final pdf = Document();

    final customfont =
        Font.ttf(await rootBundle.load("assets/Hacen Tunisia.ttf"));

    // String today = gettodayDate();
    pdf.addPage(MultiPage(
        build: (context) => <Widget>[
              _build_header(title: "Best Selling Report"),
              SizedBox(height: 10),
              Table(
                tableWidth: TableWidth.max,
                //defaultColumnWidth: FixedColumnWidth(120.0),
                //defaultColumnWidth: FixedColumnWidth(screenWidth(_)*.3),

                border: TableBorder.all(
                    color: PdfColors.grey, style: BorderStyle.solid, width: 1),
                children: [
                  TableRow(children: [
                    Column(children: [
                      Text('Product Name',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold))
                    ]),
                    Column(children: [
                      Text('Qty',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold))
                    ]),
                  ]),
                  ...list.map((e) => TableRow(children: [
                        Column(
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                  e.name.toString().length > 20
                                      ? "${e.name.toString().substring(0, 20)}..."
                                      : e.name.toString(),
                                  style: TextStyle(
                                      font: customfont, fontSize: 20)),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(e.qty.toString(),
                                  style: TextStyle(
                                      font: customfont, fontSize: 20)),
                            ),
                          ],
                        ),
                      ]))
                ],
              ),
              SizedBox(height: 20),
            ],
        footer: (context) => Container(
            alignment: Alignment.bottomRight,
            child:
                Text("Page ${context.pageNumber} of ${context.pagesCount}"))));
    return saveDocument(name: "Best Selling Report.pdf", doc: pdf);
  }

  static Future<File> generateMostProfitableReport(
    List<ProfitableVModel> list,
  ) async {
    double finalprice = 0;
    list.forEach((element) {
      finalprice += double.parse(element.total_profit.toString());
    });
    //finalprice = double.parse(finalprice.toStringAsFixed(2));
    final pdf = Document();

    final customfont =
        Font.ttf(await rootBundle.load("assets/Hacen Tunisia.ttf"));

    // String today = gettodayDate();
    pdf.addPage(MultiPage(
        build: (context) => <Widget>[
              _build_header(title: "Most Profitable Report"),
              SizedBox(height: 10),
              Table(
                tableWidth: TableWidth.max,
                //defaultColumnWidth: FixedColumnWidth(120.0),
                //defaultColumnWidth: FixedColumnWidth(screenWidth(_)*.3),

                border: TableBorder.all(
                    color: PdfColors.grey, style: BorderStyle.solid, width: 1),
                children: [
                  TableRow(children: [
                    Column(children: [
                      Text('Product Name',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold))
                    ]),
                    Column(children: [
                      Text('Qty',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold))
                    ]),
                    Column(children: [
                      Text('Total',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold))
                    ]),
                  ]),
                  ...list.map((e) => TableRow(children: [
                        Column(
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                  e.name.toString().length > 20
                                      ? "${e.name.toString().substring(0, 20)}..."
                                      : e.name.toString(),
                                  style: TextStyle(
                                      font: customfont, fontSize: 20)),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(e.qty.toString(),
                                  style: TextStyle(
                                      font: customfont, fontSize: 20)),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                  double.parse(e.total_profit.toString())
                                      .toStringAsFixed(2),
                                  style: TextStyle(
                                      font: customfont, fontSize: 20)),
                            ),
                          ],
                        ),
                      ]))
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Total  : ",
                    style: TextStyle(color: PdfColors.red, fontSize: 30),
                  ),
                  SizedBox(width: 5),
                  Text("${finalprice}  LL",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
                ],
              ),
              SizedBox(height: 20),
            ],
        footer: (context) => Container(
            alignment: Alignment.bottomRight,
            child:
                Text("Page ${context.pageNumber} of ${context.pagesCount}"))));
    return saveDocument(name: "Most Profitable Report.pdf", doc: pdf);
  }

  static Future<File> generateLowQtyReport(
    List<LowQtyVModel> list,
  ) async {
    final pdf = Document();

    final customfont =
        Font.ttf(await rootBundle.load("assets/Hacen Tunisia.ttf"));

    // String today = gettodayDate();
    pdf.addPage(MultiPage(
        build: (context) => <Widget>[
              _build_header(title: "Low Qty Products"),
              SizedBox(height: 10),
              Table(
                tableWidth: TableWidth.max,
                //defaultColumnWidth: FixedColumnWidth(120.0),
                //defaultColumnWidth: FixedColumnWidth(screenWidth(_)*.3),

                border: TableBorder.all(
                    color: PdfColors.grey, style: BorderStyle.solid, width: 1),
                children: [
                  TableRow(children: [
                    Column(children: [
                      Text('Product Name',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold))
                    ]),
                    Column(children: [
                      Text('Qty',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold))
                    ]),
                  ]),
                  ...list.map((e) => TableRow(children: [
                        Column(
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                  e.name.toString().length > 20
                                      ? "${e.name.toString().substring(0, 20)}..."
                                      : e.name.toString(),
                                  style: TextStyle(
                                      font: customfont, fontSize: 20)),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(e.qty.toString(),
                                  style: TextStyle(
                                      font: customfont, fontSize: 20)),
                            ),
                          ],
                        ),
                      ]))
                ],
              ),
              SizedBox(height: 20),
            ],
        footer: (context) => Container(
            alignment: Alignment.bottomRight,
            child:
                Text("Page ${context.pageNumber} of ${context.pagesCount}"))));
    return saveDocument(name: "Low Qty Report.pdf", doc: pdf);
  }

  static Future<File> generateEarnSpentReport(
    List<EarnSpentVmodel> list,
  ) async {
    final pdf = Document();

    final customfont =
        Font.ttf(await rootBundle.load("assets/Hacen Tunisia.ttf"));

    // String today = gettodayDate();
    pdf.addPage(MultiPage(
        build: (context) => <Widget>[
              _build_header(title: "Earn / Spent By item"),
              SizedBox(height: 10),
              Table(
                tableWidth: TableWidth.max,
                border: TableBorder.all(
                    color: PdfColors.grey, style: BorderStyle.solid, width: 1),
                children: [
                  TableRow(children: [
                    Column(children: [
                      Text('Product Name',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold))
                    ]),
                    Column(children: [
                      Text('Spent',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold))
                    ]),
                    Column(children: [
                      Text('Earn',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold))
                    ]),
                    Column(children: [
                      Text('Rest Qty',
                          style: TextStyle(
                              fontSize: 25.0, fontWeight: FontWeight.bold))
                    ]),
                  ]),
                  ...list.map((e) => TableRow(children: [
                        Column(
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                  e.name.toString().length > 20
                                      ? "${e.name.toString().substring(0, 20)}..."
                                      : e.name.toString(),
                                  style: TextStyle(
                                      font: customfont, fontSize: 20)),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(e.total_spent.toString(),
                                  style: TextStyle(
                                      font: customfont,
                                      fontSize: 20,
                                      color: PdfColors.red500)),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(e.total_earn.toString(),
                                  style: TextStyle(
                                      font: customfont,
                                      fontSize: 20,
                                      color: PdfColors.green500)),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(e.rest_qty.toString(),
                                  style: TextStyle(
                                    font: customfont,
                                    fontSize: 20,
                                  )),
                            ),
                          ],
                        ),
                      ]))
                ],
              ),
              SizedBox(height: 20),
            ],
        footer: (context) => Container(
            alignment: Alignment.bottomRight,
            child:
                Text("Page ${context.pageNumber} of ${context.pagesCount}"))));
    return saveDocument(name: "Earn_Spent.pdf", doc: pdf);
  }

  static Future<File> saveDocument({
    required String name,
    required Document doc,
  }) async {
    final bytes = await doc.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

// Store genearted Bytes
    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }

  static _build_header({String? startdate, String? enddate, String? title}) =>
      Header(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Center(
              child: Text(
                startdate != null && enddate != null
                    ? "Report from $startdate To $enddate"
                    : startdate != null && enddate == null
                        ? "Report - $startdate - "
                        : title!,
                style: TextStyle(
                  color: PdfColors.white,
                  fontSize: 25,
                ),
              ),
            ),
          ),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [PdfColors.blue200, PdfColors.blue800],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              color: PdfColors.blue400));
}
