import 'package:flutter/material.dart';
import 'package:marketsystem/controllers/products_controller.dart';
import 'package:marketsystem/shared/toast_message.dart';
import 'package:provider/provider.dart';

class ChangeQtyScreen extends StatefulWidget {
  String title;
  String barcode;
  String qty;
  ChangeQtyScreen(
      {required this.title, required this.barcode, required this.qty});

  @override
  State<ChangeQtyScreen> createState() => _ChangeQtyScreenState();
}

class _ChangeQtyScreenState extends State<ChangeQtyScreen> {
  List<String> _numbers = [
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "0",
    "00",
    "OK",
  ];

  String qty = "";

  @override
  Widget build(BuildContext context) {
    String title = this.widget.title.toString();
    String barcode = this.widget.barcode.toString();
    print("new qty " + qty);

    double screen_width = MediaQuery.of(context).size.width;
    double screen_height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(title.toString()),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Quantity"),
                        SizedBox(height: 15),
                        Text(
                          "${qty}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        )
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          if (qty.length > 0) {
                            setState(() {
                              qty = qty.substring(0, qty.length - 1);
                            });
                          }
                        },
                        icon: Icon(Icons.cancel_presentation))
                  ],
                ),
              )),
          Expanded(
            flex: 4,
            child: Container(
              child: Column(
                children: [
                  Wrap(
                    children: [
                      ..._numbers.map((e) => GestureDetector(
                          onTap: () {
                            print("item pressed " + e);
                            if (_numbers.indexOf(e) == 11) {
                              if (qty != "") {
                                context
                                    .read<ProductsController>()
                                    .onchangeQtyInBasket(barcode, qty)
                                    .then((value) {
                                  if (value == false) {
                                    showToast(
                                        message:
                                            "qty must be less then qty in store",
                                        status: ToastStatus.Error);
                                  }
                                });
                                Navigator.pop(context);
                                // return;
                              }
                            } else {
                              setState(() {
                                qty += e;
                              });
                              print("inside :" + qty);
                            }
                          },
                          child: _build_item_number(
                              screen_width / 3, screen_height * .125, e))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _build_item_number(double width, double height, String item) => Container(
        decoration:
            BoxDecoration(border: Border.all(color: Colors.grey.shade300)),
        height: height,
        width: width,
        child: Center(child: Text(item)),
      );
}
