class ProfitableVModel {
  String? name;
  String? qty;
  String? profit_per_item_on_sale;
  String? total_profit;

  ProfitableVModel.fromJson(Map<String, dynamic> map) {
    name = map['name'];
    qty = map['qty'].toString();
    profit_per_item_on_sale = map['profit_per_item_on_sale'].toString();
    total_profit = map['total_profit'].toString();
  }

  toJson() {
    return {
      'name': name,
      'qty': qty,
      'profit_per_item_on_sale': profit_per_item_on_sale ?? '',
      'total_profit': total_profit ?? '',
    };
  }
}
