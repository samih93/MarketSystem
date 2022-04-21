class DetailsFactureModel {
  String? id;
  String? barcode;
  String? name;
  String? qty;
  String? price;
  int? facture_id;
  String? facturedate;
  // For most profitable product
  String? profit_per_item;
  String? total_profit;

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
    profit_per_item =
        map['profit_per_item'] != null ? map['profit_per_item'].toString() : "";
    total_profit =
        map['total_profit'] != null ? map['total_profit'].toString() : "";
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
      'profit_per_item': profit_per_item ?? '',
      'total_profit': total_profit ?? '',
      //'facturedate': facturedate ?? '',
    };
  }
}
