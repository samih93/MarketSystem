class TransactionsVModel {
  String? name;
  String? qty;
  String? price;
  String? facturedate;

  TransactionsVModel.fromJson(Map<String, dynamic> map) {
    name = map['name'];
    qty = map['qty'].toString();
    price = map['price'].toString();
    facturedate = map['facturedate'].toString();
  }

  toJson() {
    return {
      'name': name,
      'qty': qty,
      'price': price ?? '',
      'facturedate': facturedate ?? '',
    };
  }
}
