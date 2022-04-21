class BestSellingVmodel {
  String? name;
  String? qty;

  BestSellingVmodel.fromJson(Map<String, dynamic> map) {
    name = map['name'];
    qty = map['qty'].toString();
  }

  toJson() {
    return {'name': name, 'qty': qty};
  }
}
