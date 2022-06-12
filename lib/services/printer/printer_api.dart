import 'dart:async';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:marketsystem/models/product.dart';

class PrintApi {
  static Future<List<int>> getTicket(List<ProductModel> products) async {
    double total_receipt_price = 0;
    List<int> bytes = [];
    CapabilityProfile profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);

    bytes += generator.text("Pos System",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
        linesAfter: 1);

    bytes += generator.text("Address Lorem Ipsum , .....",
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Tel: +919591708470',
        styles: PosStyles(align: PosAlign.center));

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(
          text: 'Item',
          width: 6,
          styles: PosStyles(align: PosAlign.left, bold: true)),
      PosColumn(
          text: 'Price',
          width: 2,
          styles: PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: 'Qty',
          width: 2,
          styles: PosStyles(align: PosAlign.center, bold: true)),
      PosColumn(
          text: 'Total',
          width: 2,
          styles: PosStyles(align: PosAlign.right, bold: true)),
    ]);

    products.forEach((element) {
      double totalprice_per_item = double.parse(element.qty.toString()) *
          double.parse(element.price.toString());
      total_receipt_price += totalprice_per_item;
      bytes += generator.row([
        PosColumn(
            text: "${element.name}",
            width: 6,
            styles: PosStyles(
              align: PosAlign.left,
            )),
        PosColumn(
            text: "${element.price}",
            width: 2,
            styles: PosStyles(
              align: PosAlign.center,
            )),
        PosColumn(
            text: "${element.qty}",
            width: 2,
            styles: PosStyles(align: PosAlign.center)),
        PosColumn(
            text: "${totalprice_per_item}",
            width: 2,
            styles: PosStyles(align: PosAlign.right)),
      ]);
    });

    bytes += generator.hr();

    bytes += generator.row([
      PosColumn(
          text: 'TOTAL',
          width: 4,
          styles: PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
          )),
      PosColumn(
          text: "${total_receipt_price} LL",
          width: 8,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size2,
            width: PosTextSize.size1,
          )),
    ]);

    bytes += generator.hr(ch: '=', linesAfter: 1);

    // ticket.feed(2);
    bytes += generator.text('Thank you!',
        styles: PosStyles(align: PosAlign.center, bold: true));

    bytes += generator.text("${DateTime.now().toString().split('.').first}",
        styles: PosStyles(align: PosAlign.center), linesAfter: 1);

    bytes += generator.text(
        'Note: Goods once sold will not be taken back or exchanged.',
        styles: PosStyles(align: PosAlign.center, bold: false));
    bytes += generator.cut();
    return bytes;
  }
}
