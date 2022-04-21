class ProductModel {
  String? barcode;
  String? name;
  String? price;
  String? totalprice;
  String? qty = "1";
  String? profit_per_item = "";

  ProductModel(
      {required this.barcode,
      required this.name,
      required this.price,
      required this.totalprice,
      required this.qty,
      required this.profit_per_item});

  ProductModel.fromJson(Map<String, dynamic> map) {
    this.barcode = map['barcode'];
    this.name = map['name'];
    this.price = map['price'].toString();
    this.totalprice = map['totalprice'].toString();
    this.qty = map['qty'].toString();
    this.profit_per_item = map['profit_per_item'].toString();
  }

  toJson() {
    return {
      'barcode': barcode,
      'name': name,
      'price': price,
      'totalprice': totalprice,
      'qty': qty,
      'profit_per_item': profit_per_item,
    };
  }
}
