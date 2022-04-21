class ProfitableVModel {
  String? name;
  String? qty;
  String? profit_per_item;
  String? total_profit;

  ProfitableVModel.fromJson(Map<String, dynamic> map) {
    name = map['name'];
    qty = map['qty'].toString();
    profit_per_item = map['profit_per_item'].toString();
    total_profit = map['total_profit'].toString();
  }

  toJson() {
    return {
      'name': name,
      'qty': qty,
      'profit_per_item': profit_per_item ?? '',
      'total_profit': total_profit ?? '',
    };
  }
}
