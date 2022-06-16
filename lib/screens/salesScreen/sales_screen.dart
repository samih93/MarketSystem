import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:marketsystem/controllers/printManagementController.dart';
import 'package:marketsystem/controllers/products_controller.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/screens/cash_screen/cash_screen.dart';
import 'package:marketsystem/screens/change_qty_screen/change_qty.dart';
import 'package:marketsystem/shared/components/default_button.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:marketsystem/shared/styles.dart';
import 'package:marketsystem/shared/toast_message.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class SalesScreen extends StatefulWidget {
  @override
  State<SalesScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SalesScreen> {
  List<String> headertitles = ['Name', 'Qty', ''];
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrViewcontroller;
  Barcode? barCode = null;
  bool is_onScan = false;
  bool isflashOn = true;

  var qtyController = TextEditingController();
  var receivedCashController = TextEditingController();

  bool _iscashSuccess = false;

  var text_productNameController = TextEditingController();
  var text_barcode_controller = TextEditingController();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String _change_amount = "";
  String _total_paid = "";
  String _received_cash = "";
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
    var prod_controller = Provider.of<ProductsController>(context);

    return Scaffold(
      body: prod_controller.isloadingGetProducts
          ? Center(child: CircularProgressIndicator())
          : _iscashSuccess
              ? Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: double.infinity,
                    color: defaultColor.shade300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "${_received_cash}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 30),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Received",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 25),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: Column(
                              children: [
                                Text(
                                  "${_total_paid}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 25),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Total paid",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                              ],
                            )),
                            Container(
                                height: 80,
                                child: VerticalDivider(
                                  color: Colors.white,
                                  thickness: 2,
                                )),
                            Expanded(
                                child: Column(
                              children: [
                                Text(
                                  "${_change_amount}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red.shade400,
                                      fontSize: 25),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Change",
                                  style: TextStyle(
                                      color: Colors.red.shade400, fontSize: 15),
                                ),
                              ],
                            ))
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 50,
                          child: Icon(
                            Icons.done,
                            size: 50,
                            color: defaultColor,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("Completed!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text(
                          "Transaction was Completed successfully",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        _continueButton(),
                      ],
                    ),
                  ),
                )
              : Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    if (is_onScan) _buildQr(context),
                    // Positioned(
                    //   bottom: 10,
                    //   child: _buildResult(),
                    // ),
                    if (is_onScan)
                      Positioned(
                        top: 10,
                        child: _buildControlButton(),
                      ),
                    if (!is_onScan)
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 5),
                                child: Row(
                                  children: [
                                    Expanded(child: _builddropdownSearch()),
                                    IconButton(
                                        onPressed: () {
                                          qrViewcontroller?.resumeCamera();
                                          setState(() {
                                            is_onScan = true;
                                          });
                                        },
                                        icon:
                                            Icon(Icons.qr_code_scanner_rounded))
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: prod_controller
                                                  .basket_products.length >
                                              0
                                          ? Column(
                                              children: [
                                                _build_basket_header(),
                                                Divider(
                                                  thickness: 2,
                                                  color: defaultColor,
                                                ),
                                                Expanded(
                                                  child: ListView(
                                                    children: [
                                                      ...prod_controller
                                                          .basket_products
                                                          .map((e) =>
                                                              _basket_item(e)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Container()),
                                ),
                              ),
                              _buildTotalPrice(prod_controller),
                              Container(
                                height: 10,
                                color: Colors.white,
                              ),
                              _buildSubmitRow(prod_controller),
                            ],
                          ),
                        ),
                      ),
                    // DataTable(
                    //   headingTextStyle: TextStyle(color: defaultColor),
                    //   border: TableBorder.all(width: 1, color: Colors.grey),
                    //   columns: [
                    //     ...headertitles.map((e) => _build_header_item(e))
                    //   ],
                    //   rows: [
                    //     ...prod_controller.list_ofProduct_inStore.map(
                    //         (e) =>
                    //             _build_Row(e, marketController, context)),
                    //   ],
                    // ),
                  ],
                ),
    );
  }

  _buildSubmitRow(ProductsController controller) => Container(
        width: double.infinity,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: defaultButton(
                  gradient: controller.basket_products.length == 0
                      ? null
                      : myLinearGradient,
                  background: Colors.grey,

                  //  width: MediaQuery.of(context).size.width * 0.4,
                  text: "Cash",
                  onpress: () async {
                    if (controller.basket_products.length > 0) {
                      String total_price =
                          controller.totalprice.toStringAsFixed(0).toString();
                      String res =
                          await Get.to(CashScreen(controller.totalprice));
                      print("res :" + res.toString());

                      // Print Receipt

                      setState(() {
                        _change_amount = double.parse(res).toStringAsFixed(0);
                        _total_paid = total_price;
                        _received_cash =
                            (double.parse(total_price) + double.parse(res))
                                .toStringAsFixed(0);
                        _iscashSuccess = true;
                      });
                      if (context
                          .read<PrintManagementController>()
                          .isprintautomatically) {
                        context.read<PrintManagementController>().printTicket(
                            controller.basket_products,
                            cash: _received_cash,
                            change: _change_amount);
                      } else {
                        showToast(
                          message: "enable switch button to print receipt",
                          status: ToastStatus.Warning,
                        );
                      }
                    }
                  }),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      );

  _buildControlButton() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //  qrViewcontroller!.getFlashStatus() == true
          IconButton(
              onPressed: () {
                qrViewcontroller!.getFlashStatus().then((value) {
                  setState(() {
                    isflashOn = value!;
                  });
                });
                qrViewcontroller!.toggleFlash();
              },
              icon: Icon(
                isflashOn ? Icons.flash_on : Icons.flash_off,
                color: defaultColor,
                size: 35,
              )),
          IconButton(
              onPressed: () async {
                await qrViewcontroller?.pauseCamera();
                setState(() {
                  is_onScan = false;
                });
              },
              icon: Icon(
                Icons.close,
                color: defaultColor,
                size: 35,
              ))
          // : IconButton(
          //     onPressed: () {
          //       qrViewcontroller!.toggleFlash();
          //     },
          //     icon: Icon(
          //       Icons.flash_on,
          //       color: defaultColor,
          //     ))
        ],
      );

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
      //this.context = context;
    });

    qrViewcontroller?.scannedDataStream.listen((barcode) => setState(() {
          this.barCode = barcode;
          FlutterBeep.beep();
          is_onScan = false;
          qrViewcontroller?.pauseCamera();

          context
              .read<ProductsController>()
              .fetchProductBybarCode(barcode.code.toString())
              .then((value) {
            print(value);
            if (!value)
              showToast(
                  message: "Item Not found",
                  status: ToastStatus.Error,
                  time: 4);
          });
        }));
  }

  _buildTotalPrice(ProductsController controller) => Container(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Total Price : ",
              style: TextStyle(color: Colors.red[300], fontSize: 20),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              controller.totalprice.toString() + " LL",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      );

  _continueButton() => GestureDetector(
        onTap: () {
          setState(() {
            _iscashSuccess = false;
            is_onScan = false;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.white,
          ),
          width: MediaQuery.of(context).size.width * 0.4,
          padding: EdgeInsets.all(10),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            Text(
              'New sale',
              style: TextStyle(color: defaultColor, letterSpacing: 2),
            ),
            Container(
              child: Icon(Icons.navigate_next, color: Colors.white),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: defaultColor,
              ),
            ),
          ]),
        ),
      );

  _builddropdownSearch() => Form(
        key: _formkey,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.centerRight,
              children: [
                Container(
                  height: 50,
                  child: TypeAheadField(
                    hideOnError: true,
                    textFieldConfiguration: TextFieldConfiguration(
                        enableSuggestions: false,
                        controller: text_productNameController,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                            border: UnderlineInputBorder(),
                            hintText: "Select Product ...")),
                    // suggestionsCallback: (pattern) async {
                    // return await marketController
                    //     .autocomplete_Search_forProduct(pattern);
                    // },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        //leading: Icon(Icons.shopping_cart),
                        title:
                            Text((suggestion as ProductModel).name.toString()),
                        subtitle: Text('${suggestion.price.toString()} LL'),
                      );
                    },
                    onSuggestionSelected: (Object? suggestion) async {
                      String? barcode =
                          (suggestion as ProductModel).barcode.toString();
                      await context
                          .read<ProductsController>()
                          .fetchProductBybarCode(barcode);
                      text_productNameController.clear();
                    },
                    suggestionsCallback: (String pattern) async {
                      return await context
                          .read<ProductsController>()
                          .autocomplete_Search_forProduct(pattern);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  _basket_item(ProductModel model) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name.toString(),
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                model.price.toString() + " LL ",
                style: TextStyle(fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        Expanded(
            child: GestureDetector(
          onTap: () {
            print("name " + model.name.toString());
            Get.to(ChangeQtyScreen(
                title: model.name.toString(),
                barcode: model.barcode.toString(),
                qty: model.qty.toString().trim()));
            // Alert(
            //     context: context,
            //     title: "Enter Qty",
            //     content: Column(
            //       children: <Widget>[
            //         TextField(
            //           controller: qtyController,
            //           keyboardType: TextInputType.phone,
            //           decoration: InputDecoration(
            //             labelText: 'Qty',
            //           ),
            //         ),
            //       ],
            //     ),
            //     buttons: [
            //       DialogButton(
            //         onPressed: () {

            // int? qty = int.tryParse(qtyController.text);
            // if (qty != null) {
            //   context
            //       .read<ProductsController>()
            //       .onchangeQtyInBasket(
            //           model.barcode.toString(), qtyController.text)
            //       .then((value) {
            //     if (value == false) {
            //       showToast(
            //           message: "qty must be less then qty in store",
            //           status: ToastStatus.Error);
            //     } else {
            //       showToast(
            //           message: "qty Changed",
            //           status: ToastStatus.Success);
            //     }
            //   });
            //   Navigator.pop(context);
            //   qtyController.clear();
            // } else {
            //   showToast(
            //       message: "qty  Must be a number ",
            //       status: ToastStatus.Error);
            // }
            //             },
            //             child: Text(
            //               "Ok",
            //               style: TextStyle(color: Colors.white, fontSize: 20),
            //             ),
            //           )
            //         ]).show();
          },
          child: Text(
            "${model.qty}",
            style: TextStyle(
                fontSize: 15,
                color: defaultColor,
                decoration: TextDecoration.underline),
          ),
        )),
        Expanded(
            child: IconButton(
                onPressed: () {
                  context
                      .read<ProductsController>()
                      .deleteProductFromBasket(model.barcode.toString());
                },
                icon: Icon(Icons.close))),
      ],
    );
  }

  _build_basket_header() {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Text(
            "Name",
            style: headerProductTable.copyWith(color: defaultColor),
          ),
        ),
        Expanded(
            child: Text("Qty",
                style: headerProductTable.copyWith(color: defaultColor))),
        Expanded(child: Text("")),
      ],
    );
  }
}
