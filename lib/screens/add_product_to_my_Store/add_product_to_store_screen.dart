import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:marketsystem/controllers/products_controller.dart';
import 'package:marketsystem/models/product.dart';
import 'package:marketsystem/shared/components/default_button.dart';
import 'package:marketsystem/shared/components/default_text_form.dart';
import 'package:provider/provider.dart';

class AddProductToMyStoreScreen extends StatefulWidget {
  @override
  State<AddProductToMyStoreScreen> createState() =>
      _AddProductToMyStoreScreenState();
}

class _AddProductToMyStoreScreenState extends State<AddProductToMyStoreScreen> {
  var text_productNameController = TextEditingController();

  var text_barcode_controller = TextEditingController();

  var text_qty_controller = TextEditingController();

  GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _isEnable = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Product To Store"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
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
                          enabled: _isEnable,
                          autofocus: true,
                          style: TextStyle(fontSize: 24),
                          decoration: InputDecoration(
                              border: UnderlineInputBorder(),
                              hintText: "Select Product ...")),
                      suggestionsCallback: (pattern) async {
                        return await context
                            .read<ProductsController>()
                            .autocomplete_Search_forProduct(pattern);
                      },
                      itemBuilder: (context, suggestion) {
                        return ListTile(
                          leading: Icon(Icons.shopping_cart),
                          title: Text(
                              (suggestion as ProductModel).name.toString()),
                          subtitle: Text('${suggestion.price.toString()} LL'),
                        );
                      },
                      onSuggestionSelected: (Object? suggestion) {
                        print((suggestion as ProductModel).barcode);
                        text_productNameController.text =
                            suggestion.name.toString();
                        // text_barcode_controller.text =
                        //     suggestion.barcode.toString();
                        setState(() {
                          _isEnable = false;
                        });
                      },

                      // onSuggestionSelected: (suggestion) {
                      //   Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => ProductPage(product: suggestion)
                      //   ));
                      // },
                    ),
                  ),
                  !_isEnable
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              text_productNameController.clear();
                              _isEnable = true;
                            });
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.red.shade500,
                          ))
                      : SizedBox(
                          width: 2,
                        ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              defaultTextFormField(
                  controller: text_qty_controller,
                  onvalidate: (value) {
                    if (value!.isEmpty) {
                      return "Quantity must not be empty";
                    }
                    return null;
                  },
                  inputtype: TextInputType.phone,
                  border: UnderlineInputBorder(),
                  hinttext: "Quantity"),
              SizedBox(
                height: 10,
              ),
              defaultButton(
                  text: "Save",
                  onpress: () async {
                    // if (_formkey.currentState!.validate()) {
                    //   int? qty =
                    //       int.tryParse(text_qty_controller.text.toString());
                    //   if (qty != null) {
                    //     marketController
                    //         .insertProductToStore(ProductModel.Store(
                    //             barcode: text_barcode_controller.text,
                    //             name: text_productNameController.text,
                    //             qty: text_qty_controller.text))
                    //         .then((value) {
                    //       print(marketController
                    //           .statusInsertToStoreBodyMessage);
                    //       if (marketController.statusInsertToStoreMessage ==
                    //           ToastStatus.Error) {
                    //         showToast(
                    //             message: marketController
                    //                 .statusInsertToStoreBodyMessage
                    //                 .toString(),
                    //             status: marketController
                    //                 .statusInsertToStoreMessage.value);
                    //       } else {
                    //         text_productNameController.clear();
                    //         text_barcode_controller.clear();
                    //         text_qty_controller.clear();
                    //         Get.back();
                    //         showToast(
                    //             message: marketController
                    //                 .statusInsertToStoreBodyMessage
                    //                 .toString(),
                    //             status: marketController
                    //                 .statusInsertToStoreMessage.value);
                    //       }
                    //     });
                    //   } else {
                    //     showToast(
                    //         message: "Quantity Must be a number ",
                    //         status: ToastStatus.Error);
                    //   }
                    // }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
