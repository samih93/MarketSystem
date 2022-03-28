import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marketsystem/screens/add_product_to_my_Store/add_product_to_store_screen.dart';

class MyStoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("My Store")),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Get.to(AddProductToMyStoreScreen());
          }),
    );
  }
}
