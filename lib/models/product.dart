import 'package:qr_code_scanner/qr_code_scanner.dart';

class ProductModel {
  String? barcode;
  String? name;
  String? price;
  String? qty = "1";

  ProductModel(
      {required this.barcode, required this.name, required this.price});

  // NOTE needed to add product to store
  ProductModel.Store(
      {required this.barcode, required this.name, required this.qty});

  ProductModel.fromJson(Map<String, dynamic> map) {
    this.barcode = map['barcode'];
    this.name = map['name'];
    this.price = map['price'].toString();
  }

  toJson() {
    return {
      'barcode': barcode,
      'name': name,
      'price': price,
    };
  }

  // NOTE needed to add product to store
  toJson_Store() {
    return {'barcode': barcode, 'name': name, 'qty': qty};
  }

  ProductModel.fromJson_Store(Map<String, dynamic> map) {
    this.barcode = map['barcode'];
    this.name = map['name'];
    this.qty = map['qty'].toString();
  }
}
