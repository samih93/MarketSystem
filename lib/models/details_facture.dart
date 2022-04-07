class DetailsFactureModel {
  String? id;
  String? barcode;
  String? name;
  String? qty;
  int? facture_id;

  DetailsFactureModel(
      {required this.barcode,
      required this.name,
      required this.qty,
      required this.facture_id});

  DetailsFactureModel.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    barcode = map['barcode'];
    name = map['name'];
    qty = map['qty'];
    facture_id = map['facture_id'];
  }

  toJson() {
    return {
      'barcode': barcode,
      'name': name,
      'qty': qty,
      'facture_id': facture_id,
    };
  }
}
