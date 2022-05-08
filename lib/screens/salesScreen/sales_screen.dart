import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:marketsystem/controllers/products_controller.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/shared/components/default_button.dart';
import 'package:marketsystem/shared/components/default_text_form.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:marketsystem/shared/styles.dart';
import 'package:marketsystem/shared/toast_message.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class SalesScreen extends StatefulWidget {
  @override
  State<SalesScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SalesScreen> {
  List<String> headertitles = ['Name', 'Qty', ''];
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrViewcontroller;
  Barcode? barCode = null;
  bool isflashOn = true;

  var qtyController = TextEditingController();
  var receivedCashController = TextEditingController();

  bool _iscashSuccess = false;

  var text_productNameController = TextEditingController();
  var text_barcode_controller = TextEditingController();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _isEnable = true;
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
                        Text("Order Completed!",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        Text(
                          "Your Order was Completed successfully",
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
                    _buildQr(context),
                    Positioned(
                      bottom: 10,
                      child: _buildResult(),
                    ),
                    Positioned(
                      top: 10,
                      child: _buildControlButton(),
                    ),
                    if (barCode != null)
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
                                          qrViewcontroller!.resumeCamera();
                                          setState(() {
                                            barCode = null;
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
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        "Name",
                                                        style: headerProductTable
                                                            .copyWith(
                                                                color:
                                                                    defaultColor),
                                                      ),
                                                    ),
                                                    Expanded(
                                                        child: Text("Qty",
                                                            style: headerProductTable
                                                                .copyWith(
                                                                    color:
                                                                        defaultColor))),
                                                    Expanded(child: Text("")),
                                                  ],
                                                ),
                                                Divider(
                                                  thickness: 2,
                                                  color: defaultColor,
                                                ),
                                                ...prod_controller
                                                    .basket_products
                                                    .map(
                                                        (e) => _basket_item(e)),
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
                  onpress: () {
                    if (controller.basket_products.length > 0)
                      Alert(
                          context: context,
                          //  title: "Cash",
                          content: Column(
                            children: <Widget>[
                              Text(
                                'Total Amount',
                                style: TextStyle(fontSize: 20),
                              ),
                              Text(
                                '${controller.totalprice.toString()} LL',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          buttons: [
                            DialogButton(
                              onPressed: () {
                                controller.addFacture();
                                // controller.clearBasket();
                                setState(() {
                                  barCode = null;
                                  _iscashSuccess = true;
                                });

                                Navigator.pop(context);
                              },
                              child: Text(
                                "Enter",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            )
                          ]).show();
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
          qrViewcontroller?.pauseCamera();
          FlutterBeep.beep();
          context
              .read<ProductsController>()
              .fetchProductBybarCode(barcode.code.toString());
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
            qrViewcontroller!.resumeCamera();
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
              'Continue',
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

  _buildResult() => GestureDetector(
        onTap: () {
          setState(() {
            this.barCode = Barcode('', BarcodeFormat.codabar, []);
          });
        },
        child: Container(
          decoration: BoxDecoration(gradient: myLinearGradient),
          padding: EdgeInsets.all(15),
          child: Text(
            "Continue Without Scan",
            style: TextStyle(fontSize: 24, color: Colors.white),
          ),
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
                        controller: text_productNameController,
                        // enabled: _isEnable,
                        autofocus: true,
                        style: TextStyle(fontSize: 24),
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
                      print((suggestion as ProductModel).barcode);
                      await context
                          .read<ProductsController>()
                          .fetchProductBybarCode(text_barcode_controller.text);
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
              Text(model.name.toString()),
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
                      context
                          .read<ProductsController>()
                          .onchangeQtyInBasket(
                              model.barcode.toString(), qtyController.text)
                          .then((value) {
                        if (value == false) {
                          showToast(
                              message: "qty must be less then qty in store",
                              status: ToastStatus.Error);
                        } else {
                          showToast(
                              message: "qty Changed",
                              status: ToastStatus.Success);
                        }
                      });
                      Navigator.pop(context);
                      qtyController.clear();
                    },
                    child: Text(
                      "Ok",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  )
                ]).show();
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
}
