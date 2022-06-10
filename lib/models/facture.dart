class FactureModel {
  String? id;
  String? price;
  String? facturedate;

  FactureModel({required this.price, required this.facturedate});

  FactureModel.fromJson(Map<String, dynamic> map) {
    id = map['id'] != null ? map['id'].toString() : '';
    price = map['price'] != null ? map['price'].toString() : '';
    facturedate =
        map['facturedate'] != null ? map['facturedate'].toString() : '';
  }

  toJson() {
    return {'price': price, 'facturedate': facturedate};
  }
}
