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

getCurrentYear(DateTime date) => int.parse(date.toString().split("-")[0]);
getCurrentMonth(DateTime date) {
  var month = int.parse(date.toString().split("-")[1]);
  return month < 10 ? "0$month" : month;
}

getFirstDayInMonth(DateTime date) =>
    int.parse(date.toString().split(" ")[0].split("-")[2]);

getLastDayInCurrentMonth(DateTime date) =>
    new DateTime(2013, int.parse(getCurrentMonth(date)) + 1, 0).day;

getCurrentDayInMonth(int i) => i < 10 ? "0$i" : i;

String databasepath = "";
