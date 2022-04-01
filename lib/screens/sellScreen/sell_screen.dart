import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketsystem/layout/market_controller.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/shared/components/default_button.dart';
import 'package:marketsystem/shared/components/default_text_form.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:marketsystem/shared/styles.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SellScreen extends StatefulWidget {
  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  List<String> headertitles = ['Name', 'BarCode', 'Price', 'Qty', ''];
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrViewcontroller;
  Barcode? barCode = null;

  var qtyController = TextEditingController();
  var receivedCashController = TextEditingController();

  var marketController_needed = Get.find<MarketController>();

  String restOfCash = "";

  @override
  void dispose() {
    // TODO: implement dispose
    this.qrViewcontroller?.dispose();
    super.dispose();
  }

  void reassemble() async {
    super.reassemble();
    if (Platform.isAndroid) {
      await qrViewcontroller?.pauseCamera();
    }
    qrViewcontroller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MarketController>(
      init: Get.find<MarketController>(),
      builder: (marketController) => Scaffold(
        body: marketController.isloadingGetProducts
            ? Center(child: CircularProgressIndicator())
            : Stack(
                alignment: Alignment.topCenter,
                children: [
                  _buildQr(context),

                  Positioned(
                    top: 10,
                    child: _buildControlButton(),
                  ),
                  if (barCode != null)
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Expanded(
                            child: Container(
                              width: double.infinity,
                              color: Colors.white,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: DataTable(
                                      headingTextStyle:
                                          TextStyle(color: defaultColor),
                                      border: TableBorder.all(
                                          width: 1, color: Colors.grey),
                                      columns: [
                                        ...headertitles
                                            .map((e) => _build_header_item(e))
                                      ],
                                      rows: [
                                        ...marketController.basket_products
                                            .map((e) => _build_Row(e, context)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Total Price : ",
                                  style: TextStyle(
                                      color: Colors.red[300], fontSize: 20),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  marketController.totalprice.toString() +
                                      " LL",
                                  style: TextStyle(fontSize: 20),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 10,
                            color: Colors.white,
                          ),
                          _buildSubmitRow(),
                        ],
                      ),
                    ),
                  // DataTable(
                  //   headingTextStyle: TextStyle(color: defaultColor),
                  //   border: TableBorder.all(width: 1, color: Colors.grey),
                  //   columns: [
                  //     ...headertitles.map((e) => _build_header_item(e))
                  //   ],
                  //   rows: [
                  //     ...marketController.list_ofProduct_inStore.map(
                  //         (e) =>
                  //             _build_Row(e, marketController, context)),
                  //   ],
                  // ),
                ],
              ),
      ),
    );
  }

  _buildSubmitRow() => Container(
        width: double.infinity,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: defaultButton(
                  width: MediaQuery.of(context).size.width * 0.4,
                  text: "Cash",
                  onpress: () {
                    Alert(
                        context: context,
                        title: "Cash",
                        content: Column(
                          children: <Widget>[
                            Text(
                              'Total : ${marketController_needed.totalprice.toString()}',
                              style: TextStyle(fontSize: 20),
                            ),
                            TextField(
                              onSubmitted: ((value) {
                                setState(() {
                                  restOfCash = (double.parse(value) -
                                          marketController_needed.totalprice)
                                      .toString();
                                });
                              }),
                              controller: receivedCashController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: 'Received Cash',
                              ),
                            ),
                            Text("Rest : $restOfCash"),
                          ],
                        ),
                        buttons: [
                          DialogButton(
                            onPressed: () {
                              //Navigator.pop(context);
                            },
                            child: Text(
                              "Enter",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          )
                        ]).show();
                  }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: defaultButton(
                  width: MediaQuery.of(context).size.width * 0.4,
                  text: "Add More",
                  onpress: () {
                    qrViewcontroller!.resumeCamera();
                    setState(() {
                      barCode = null;
                    });
                  }),
            ),
          ],
        ),
      );

  _buildControlButton() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              onPressed: () {
                qrViewcontroller!.toggleFlash();
              },
              icon: Icon(
                Icons.flash_on,
                color: defaultColor,
              ))
        ],
      );

  _build_header_item(String headerTitle) => DataColumn(
      label: Text(headerTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          )));

  _build_Row(ProductModel model, BuildContext context) => DataRow(cells: [
        DataCell(Text(model.name.toString())),
        DataCell(Text(model.barcode.toString())),
        DataCell(Text(model.price.toString())),
        DataCell(
            Text(
              model.qty.toString(),
              style: TextStyle(
                  color: defaultColor, decoration: TextDecoration.underline),
            ), onTap: () {
          Alert(
              context: context,
              title: "Enter Qty",
              content: Column(
                children: <Widget>[
                  TextField(
                    controller: qtyController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Qty',
                    ),
                  ),
                ],
              ),
              buttons: [
                DialogButton(
                  onPressed: () {
                    marketController_needed.onchangeQtyInBasket(
                        model.barcode.toString(), qtyController.text);
                    Navigator.pop(context);
                    qtyController.clear();
                  },
                  child: Text(
                    "Ok",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                )
              ]).show();
        }),
        DataCell(IconButton(
            onPressed: () {
              marketController_needed
                  .deleteProductFromBasket(model.barcode.toString());
            },
            icon: Icon(Icons.close))),
      ]);

  _buildQr(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreatedCallback,
        overlay: QrScannerOverlayShape(
            borderColor: defaultColor,
            borderWidth: 7,
            borderLength: 20,
            borderRadius: 10,
            cutOutSize: MediaQuery.of(context).size.width * 0.7),
      );

  void onQRViewCreatedCallback(QRViewController controller) {
    setState(() {
      this.qrViewcontroller = controller;
    });

    qrViewcontroller?.scannedDataStream.listen((barcode) => setState(() {
          this.barCode = barcode;
          qrViewcontroller?.pauseCamera();
          marketController_needed
              .fetchProductBybarCode(barcode.code.toString());
        }));
  }
}
