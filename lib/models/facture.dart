class FactureModel {
  String? id;
  String? price;
  String? facturedate;

  FactureModel({required this.price, required this.facturedate});

  FactureModel.fromJson(Map<String, dynamic> map) {
    id = map['id'];
    price = map['price'];
    facturedate = map['facturedate'];
  }

  toJson() {
    return {'price': price, 'facturedate': facturedate};
  }
}
