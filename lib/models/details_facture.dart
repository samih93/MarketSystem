class DetailsFactureModel {
  String? id;
  String? barcode;
  String? name;
  String? qty;
  String? price;
  int? facture_id;
  String? facturedate;
  // For most profitable product

  DetailsFactureModel(
      {required this.barcode,
      required this.name,
      required this.qty,
      required this.price,
      required this.facture_id});

  DetailsFactureModel.fromJson(Map<String, dynamic> map) {
    id = map['id'] != null ? map['id'].toString() : "";
    barcode = map['barcode'];
    name = map['name'];
    qty = map['qty'] != null ? map['qty'].toString() : "";
    price = map['price'] != null ? map['price'].toString() : "";

    facture_id = map['facture_id'];
    facturedate = map['facturedate'];
  }

  toJson() {
    return {
      'barcode': barcode,
      'name': name,
      'qty': qty,
      'price': price,
      'facture_id': facture_id,
    };
  }
}
