class EarnSpentVmodel {
  String? name;
  String? total_earn;
  String? total_spent;
  String? rest_qty;

  EarnSpentVmodel.fromJson(Map<String, dynamic> map) {
    name = map['name'];
    total_earn = map['total_earn'].toString();
    total_spent = map['total_spent'].toString();
    rest_qty = map['rest_qty'].toString();
  }

  toJson() {
    return {
      'name': name,
      'total_earn': total_earn ?? '',
      'total_spent': total_spent ?? '',
      'rest_qty': rest_qty ?? '',
    };
  }
}
