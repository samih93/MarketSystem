import 'package:qr_code_scanner/qr_code_scanner.dart';

class ProductModel {
  String? barcode;
  String? name;
  String? price;

  ProductModel(
      {required this.barcode, required this.name, required this.price});

  ProductModel.fromJson(Map<String, dynamic> map) {
    this.barcode = map['barcode'];
    this.name = map['name'];
    this.price = map['price'];
  }

  toJson() {
    return {
      'barcode': barcode,
      'name': name,
      'price': price,
    };
  }
}
