import 'package:flutter/material.dart';

TextStyle get headerProductTable {
  return TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 25,
  );
}

LinearGradient get myLinearGradient {
  return LinearGradient(
    colors: [
      const Color(0xFF3366FF),
      const Color(0xFF00CCFF),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

LinearGradient get myDisabledGradient {
  return LinearGradient(
    colors: [
      Color.fromARGB(255, 82, 83, 87),
      Color.fromARGB(255, 135, 140, 141),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
