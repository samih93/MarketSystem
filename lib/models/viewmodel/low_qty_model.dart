class LowQtyVModel {
  String? name;
  String? qty;

  LowQtyVModel.fromJson(Map<String, dynamic> map) {
    name = map['name'];
    qty = map['qty'].toString();
  }

  toJson() {
    return {'name': name, 'qty': qty};
  }
}
