class DetailsFactureModel {
  String? id;
  String? barcode;
  String? name;
  String? qty;
  String? price;
  int? facture_id;

  DetailsFactureModel(
      {required this.barcode,
      required this.name,
      required this.qty,
      required this.price,
      required this.facture_id});

  DetailsFactureModel.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    barcode = map['barcode'];
    name = map['name'];
    qty = map['qty'];
    price = map['price'];
    facture_id = map['facture_id'];
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
