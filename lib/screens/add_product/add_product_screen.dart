import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketsystem/layout/market_controller.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/screens/add_product/add_product_controller.dart';
import 'package:marketsystem/screens/manage_products/manage_products.dart';
import 'package:marketsystem/shared/components/default_button.dart';
import 'package:marketsystem/shared/components/default_text_form.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:marketsystem/shared/styles.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class AddProductScreen extends StatefulWidget {
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrViewcontroller;
  Barcode? barCode;

  var productbarcodeController_text = TextEditingController();
  var productNameController_text = TextEditingController();
  var productPriceController_text = TextEditingController();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  var add_product_controller_nedded = Get.put(AddProductController());
  var marketController_needed = Get.find<MarketController>();

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
    return GetBuilder<AddProductController>(
      init: AddProductController(),
      builder: (controller) => Scaffold(
        body: Stack(
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _build_Form(),
                        SizedBox(
                          height: 15,
                        ),
                        _buildSubmitRow(controller),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  _buildResult() => Container(
        decoration: BoxDecoration(color: Colors.white24),
        padding: EdgeInsets.all(15),
        child: SelectableText(
          barCode != null ? barCode!.code.toString() : "Scanning...",
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
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
    });

    qrViewcontroller?.scannedDataStream.listen((barcode) => setState(() {
          this.barCode = barcode;
          qrViewcontroller?.pauseCamera();
        }));
  }

  _build_Form() => SingleChildScrollView(
        child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextFormField(
                    initialValue: barCode!.code,
                    enabled: false,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                    decoration: InputDecoration(hintText: "Barcode..."),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  defaultTextFormField(
                      onvalidate: (value) {
                        if (value!.isEmpty) {
                          return "Name must not be empty";
                        }
                      },
                      inputtype: TextInputType.name,
                      border: UnderlineInputBorder(),
                      hinttext: "Name...",
                      controller: productNameController_text),
                  SizedBox(
                    height: 5,
                  ),
                  defaultTextFormField(
                      onvalidate: (value) {
                        if (value!.isEmpty) {
                          return "Price must not be empty";
                        }
                      },
                      inputtype: TextInputType.name,
                      border: UnderlineInputBorder(),
                      hinttext: "Price...",
                      controller: productPriceController_text),
                ],
              ),
            )),
      );

  _buildSubmitRow(AddProductController _controller) => Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: defaultButton(
                width: MediaQuery.of(context).size.width * 0.4,
                text: "Save",
                onpress: () {
                  if (_formkey.currentState!.validate()) {
                    print("valid");

                    _controller
                        .insertProductByModel(
                            model: ProductModel(
                                barcode: barCode!.code.toString(),
                                name: productNameController_text.text,
                                price: productPriceController_text.text))
                        .then((value) {
                      print("status MEssage :" +
                          _controller.statusMessage.toString());
                      print("status insert message :" +
                          _controller.statusInsertMessage.toString());
                      //NOTE after adding new product i need to get all product
                      marketController_needed.getAllProduct().then((value) {
                        setState(() {
                          barCode = null;
                        });
                        productNameController_text.clear();
                        productPriceController_text.clear();
                        Get.off(ManageProductsScreen());
                      });
                    });
                  } else {
                    print("invalid");
                  }
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: defaultButton(
                width: MediaQuery.of(context).size.width * 0.4,
                text: "Rescan",
                onpress: () {
                  productNameController_text.clear();
                  productPriceController_text.clear();
                  qrViewcontroller!.resumeCamera();
                  setState(() {
                    barCode = null;
                  });
                }),
          ),
        ],
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
}
