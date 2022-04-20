import 'package:flutter/material.dart';

final defaultColor = Colors.blue;

//FOrmat  dd-mm-yyyy
gettodayDate() {
  DateTime now = DateTime.now();
  String year = now.year.toString();
  String day = now.day.toString();
  String month = int.parse(now.month.toString()) < 10
      ? "0" + now.month.toString()
      : now.month.toString();

  return year + "-" + month + "-" + day;
}

String databasepath ="";
