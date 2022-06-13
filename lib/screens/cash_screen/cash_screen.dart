import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketsystem/controllers/products_controller.dart';
import 'package:marketsystem/shared/components/default_button.dart';
import 'package:marketsystem/shared/components/default_text_form.dart';
import 'package:provider/provider.dart';

class CashScreen extends StatelessWidget {
  double total_amount;
  CashScreen(this.total_amount);

  var text_receivedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    text_receivedController.text = total_amount.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text("Cash"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(children: [
          Column(
            children: [
              Text(
                "$total_amount",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Total amount due",
                style: TextStyle(color: Colors.grey.shade500, fontSize: 15),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cash Received",
                style: TextStyle(color: Colors.green.shade300),
              ),
              defaultTextFormField(
                  inputtype: TextInputType.phone,
                  controller: text_receivedController,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      text_receivedController.clear();
                    },
                  ),
                  border: UnderlineInputBorder()),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          defaultButton(
              text: "Cash",
              onpress: () {
                //NOTE close keyboard befor back cz keyboard dispay over previous screen and show an error
                FocusScope.of(context).unfocus();
                String change =
                    (double.parse(text_receivedController.text.toString()) -
                            total_amount)
                        .toString();
                context.read<ProductsController>().addFacture().then((value) {
                  Get.back(
                    result: change,
                  );
                });
              }),
        ]),
      ),
    );
  }
}
