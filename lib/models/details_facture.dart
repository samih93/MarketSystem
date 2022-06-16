class DetailsFactureModel {
  String? id;
  String? barcode;
  String? name;
  String? qty;
  String? price;
  String? totalprice;
  int? facture_id;
  String? profit_per_item_on_sale;
  String? facturedate;
  // For most profitable product

  DetailsFactureModel(
      {required this.barcode,
      required this.name,
      required this.qty,
      required this.price,
      required this.profit_per_item_on_sale,
      required this.facture_id});

  DetailsFactureModel.fromJson(Map<String, dynamic> map) {
    id = map['id'] != null ? map['id'].toString() : "";
    barcode = map['barcode'];
    name = map['name'];
    qty = map['qty'] != null ? map['qty'].toString() : "";
    price = map['price'] != null ? map['price'].toString() : "";
    totalprice = map['totalprice'] != null ? map['totalprice'].toString() : "";

    facture_id = map['facture_id'];
    profit_per_item_on_sale = map['profit_per_item_on_sale'] != null
        ? map['profit_per_item_on_sale'].toString()
        : "";
    facturedate = map['facturedate'];
  }

  toJson() {
    return {
      'barcode': barcode,
      'name': name,
      'qty': qty,
      'price': price,
      //  'totalprice': totalprice,
      'facture_id': facture_id,
      'profit_per_item_on_sale': profit_per_item_on_sale
    };
  }
}
