import 'dart:io';

import 'package:flutter/services.dart';
import 'package:marketsystem/models/details_facture.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:marketsystem/shared/styles.dart';
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

  static Future<File> generateReportByDate(
      List<DetailsFactureModel> list, String reportDate) async {
    double finalprice = 0;
    list.forEach((element) {
      finalprice += double.parse(element.price.toString());
    });
    final pdf = Document();

    final customfont =
        Font.ttf(await rootBundle.load("assets/Hacen Tunisia.ttf"));

    // String today = gettodayDate();
    pdf.addPage(MultiPage(
        build: (context) => <Widget>[
              _build_header(reportDate),
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
                      Text('Product Name', style: TextStyle(fontSize: 20.0))
                    ]),
                    Column(children: [
                      Text('Qty', style: TextStyle(fontSize: 20.0))
                    ]),
                    Column(children: [
                      Text('Total Price', style: TextStyle(fontSize: 20.0))
                    ]),
                  ]),
                  ...list.map((e) => TableRow(children: [
                        Column(
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(e.name.toString(),
                                  style: TextStyle(font: customfont)),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(e.qty.toString(),
                                  style: TextStyle(font: customfont)),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(e.price.toString(),
                                  style: TextStyle(font: customfont)),
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
                  Text("$finalprice",
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
    return saveDocument(name: 'report_${reportDate}.pdf', doc: pdf);
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

  static _build_header(String title) => Header(
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Center(
          child: Text(
            "Report $title",
            style: TextStyle(color: PdfColors.white, fontSize: 25),
          ),
        ),
      ),
      decoration: BoxDecoration(color: PdfColors.red300));
}
