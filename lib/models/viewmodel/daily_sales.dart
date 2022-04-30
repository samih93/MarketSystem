class DailySalesVm {
  int? day_in_month;
  double? total_sales_in_day;

  DailySalesVm({this.day_in_month, this.total_sales_in_day});
  DailySalesVm.fromJson(Map<String, dynamic> map) {
    day_in_month = map['day_in_month'];
    total_sales_in_day = map['total_sales_in_day'] != null
        ? double.parse(map['total_sales_in_day'].toString())
        : 0;
  }

  toJson() {
    return {
      'day_in_month': day_in_month,
      'total_sales_in_day': total_sales_in_day
    };
  }
}
