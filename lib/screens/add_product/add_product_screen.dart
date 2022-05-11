import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:get/get.dart';
import 'package:marketsystem/controllers/products_controller.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/shared/components/default_button.dart';
import 'package:marketsystem/shared/components/default_text_form.dart';
import 'package:marketsystem/shared/constant.dart';
import 'package:marketsystem/shared/styles.dart';
import 'package:marketsystem/shared/toast_message.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class AddProductScreen extends StatefulWidget {
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrViewcontroller;
  Barcode? barCode = null;
  bool is_onScan = false;
  bool isflashOn = true;

//For fields if has data

  var productbarcodeController_text = TextEditingController();
  var productNameController_text = TextEditingController();
  var productPriceController_text = TextEditingController();
  var productTotalPriceController_text = TextEditingController();
  var productQtyController = TextEditingController();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

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
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: myLinearGradient,
          ),
        ),
        title: Text("Add New Product"),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          if (is_onScan) _buildQr(context),
          if (is_onScan)
            Positioned(
              top: 10,
              child: _buildControlButton(),
            ),
          if (!is_onScan)
            Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _build_Form(context),
                    SizedBox(
                      height: 15,
                    ),
                    _buildSubmitRow(context),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

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

    qrViewcontroller?.scannedDataStream.listen((barcode) {
      setState(() {
        this.barCode = barcode;
        FlutterBeep.beep();
        is_onScan = false;
        qrViewcontroller?.pauseCamera();

        productbarcodeController_text.text = barcode.code.toString();
      });
    });
  }

  _build_Form(BuildContext context) {
    if (barCode != null) {
      //NOTE check if product exist
      context
          .read<ProductsController>()
          .getProductbyBarcode(productbarcodeController_text.text.toString())
          .then((value) {
        if (value != null) {
          productNameController_text.text = value.name.toString();
          productPriceController_text.text = value.price.toString();
        }
        // print("is product exist " +
        //     context.read<ProductsController>().isProductExist.toString());
      });
    }

    return Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              defaultTextFormField(
                  onvalidate: (value) {
                    if (value!.isEmpty) {
                      return "barcode must not be empty";
                    }
                    return null;
                  },
                  // readonly: context.read<ProductsController>().isProductExist
                  //     ? true
                  //     : false,
                  inputtype: TextInputType.name,
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          is_onScan = true;
                        });
                      },
                      icon: Icon(Icons.qr_code_scanner)),
                  border: UnderlineInputBorder(),
                  hinttext: "Barcode...",
                  controller: productbarcodeController_text),
              SizedBox(
                height: 5,
              ),
              defaultTextFormField(
                  onvalidate: (value) {
                    if (value!.isEmpty) {
                      return "Name must not be empty";
                    }
                    return null;
                  },
                  readonly: context.read<ProductsController>().isProductExist
                      ? true
                      : false,
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
                    return null;
                  },
                  inputtype: TextInputType.phone,
                  border: UnderlineInputBorder(),
                  hinttext: "Price per item...",
                  controller: productPriceController_text),
              SizedBox(
                height: 5,
              ),
              defaultTextFormField(
                  onvalidate: (value) {
                    if (value!.isEmpty) {
                      return "Qty must not be empty";
                    }
                    return null;
                  },
                  inputtype: TextInputType.phone,
                  border: UnderlineInputBorder(),
                  hinttext: "qty...",
                  controller: productQtyController),
              SizedBox(
                height: 5,
              ),
              defaultTextFormField(
                  onvalidate: (value) {
                    if (value!.isEmpty) {
                      return "Total Price must not be empty";
                    }
                    return null;
                  },
                  inputtype: TextInputType.phone,
                  border: UnderlineInputBorder(),
                  hinttext: "Total Price...",
                  controller: productTotalPriceController_text),
            ],
          ),
        ));
  }

  _buildSubmitRow(BuildContext context) {
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: defaultButton(
              //width: MediaQuery.of(context).size.width * 0.4,
              text: "Save",
              onpress: () async {
                if (_formkey.currentState!.validate()) {
                  int? price = int.tryParse(productPriceController_text.text);
                  int? qty = int.tryParse(productQtyController.text);
                  int? totalprice =
                      int.tryParse(productTotalPriceController_text.text);
                  if (price != null && qty != null && totalprice != null) {
                    print("valid");
                    String profit_per_item =
                        ((qty * price - totalprice) / qty).toString();
                    context
                        .read<ProductsController>()
                        .insertProductByModel(
                            model: ProductModel(
                                barcode: productbarcodeController_text.text,
                                name: productNameController_text.text,
                                price: productPriceController_text.text,
                                totalprice:
                                    productTotalPriceController_text.text,
                                qty: productQtyController.text,
                                profit_per_item: profit_per_item))
                        .then((value) {
                      if (context
                              .read<ProductsController>()
                              .statusInsertMessage ==
                          ToastStatus.Error) {
                        showToast(
                            message: context
                                .read<ProductsController>()
                                .statusInsertBodyMessage
                                .toString(),
                            status: context
                                .read<ProductsController>()
                                .statusInsertMessage);
                      } else {
                        productbarcodeController_text.clear();
                        productNameController_text.clear();
                        productPriceController_text.clear();
                        productQtyController.clear();
                        // marketController_needed.onchangeIndex(0);

                        Get.back();
                        showToast(
                            message: context
                                .read<ProductsController>()
                                .statusInsertBodyMessage
                                .toString(),
                            status: context
                                .read<ProductsController>()
                                .statusInsertMessage);
                      }
                    });
                  } else {
                    showToast(
                        message: "Price, Total Price Or Qty Must be a number ",
                        status: ToastStatus.Error);
                  }
                } else {
                  print("invalid");
                }
              }),
        ),
      ],
    );
  }

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
}
