import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketsystem/controllers/products_controller.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/shared/components/default_text_form.dart';
import 'package:marketsystem/shared/toast_message.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatelessWidget {
  ProductModel model;
  EditProductScreen({required this.model});

  var productbarcodeController_text = TextEditingController();
  var productNameController_text = TextEditingController();
  var productPriceController_text = TextEditingController();
  var productTotalPriceController_text = TextEditingController();
  var productQtyController_text = TextEditingController();
  var profitperitemcontroller_text = TextEditingController();
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    productNameController_text.text = model.name.toString();
    productbarcodeController_text.text = model.barcode.toString();
    productPriceController_text.text = model.price.toString();
    productQtyController_text.text = model.qty.toString();
    profitperitemcontroller_text.text = model.profit_per_item.toString();
    var prod_controller = Provider.of<ProductsController>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("${model.name}"),
        actions: [
          OutlinedButton(
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  int? price = int.tryParse(productPriceController_text.text);
                  int? qty = int.tryParse(productQtyController_text.text);
                  int? totalprice =
                      int.tryParse(productQtyController_text.text);
                  if (price != null && qty != null && totalprice != null) {
                    print('QTY : ' + productQtyController_text.text.toString());
                    String profit_per_item =
                        ((qty * price - totalprice) / qty).toString();
                    prod_controller
                        .updateProduct(ProductModel(
                            barcode: model.barcode,
                            name: productNameController_text.text,
                            price: productPriceController_text.text,
                            totalprice: productTotalPriceController_text.text,
                            qty: productQtyController_text.text,
                            profit_per_item: profit_per_item))
                        .then((value) {
                      Get.back();
                      showToast(
                          message: prod_controller.statusUpdateBodyMessage,
                          status: prod_controller.statusUpdateMessage);
                    });
                  } else {
                    showToast(
                        message: "Price,Total Price Or Qty Must be a number ",
                        status: ToastStatus.Error);
                  }
                }
              },
              child: Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: _build_Form(),
    );
  }

  _build_Form() => SingleChildScrollView(
        child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: productbarcodeController_text,
                    enabled: false,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                    decoration: InputDecoration(label: Text("Barcode...")),
                  ),
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
                      inputtype: TextInputType.name,
                      border: UnderlineInputBorder(),
                      text: "Name...",
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
                      text: "Price...",
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
                      text: "Qty...",
                      controller: productQtyController_text),
                  defaultTextFormField(
                      readonly: true,
                      inputtype: TextInputType.phone,
                      border: UnderlineInputBorder(),
                      text: "current profit per item...",
                      controller: profitperitemcontroller_text),
                ],
              ),
            )),
      );
}
