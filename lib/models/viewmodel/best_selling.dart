class BestSellingVmodel {
  String? name;
  String? qty;

  BestSellingVmodel({required this.name, required this.qty});
  
  BestSellingVmodel.fromJson(Map<String, dynamic> map) {
    name = map['name'];
    qty = map['qty'].toString();
  }

  toJson() {
    return {'name': name, 'qty': qty};
  }
}
