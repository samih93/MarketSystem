import 'package:flutter/material.dart';

final defaultColor = Colors.blue;

//FOrmat  dd-mm-yyyy
gettodayDate() {
  DateTime now = DateTime.now();
  String today = now.day.toString() +
      "-" +
      now.month.toString() +
      "-" +
      now.year.toString();
  return today;
}
