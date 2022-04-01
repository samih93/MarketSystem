import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ProductModel {
  String? barcode;
  String? name;
  String? price;
  String? qty = "1";

  ProductModel(
      {required this.barcode,
      required this.name,
      required this.price,
      required this.qty});

  ProductModel.fromJson(Map<String, dynamic> map) {
    this.barcode = map['barcode'];
    this.name = map['name'];
    this.price = map['price'].toString();
    this.qty = map['qty'].toString();
  }

  toJson() {
    return {'barcode': barcode, 'name': name, 'price': price, 'qty': qty};
  }
}
