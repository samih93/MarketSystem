import 'package:flutter/material.dart';
import 'package:marketsystem/shared/constant.dart';

Widget defaultTextFormField(
        {TextEditingController? controller,
        required TextInputType inputtype,
        Function(String?)? onfieldsubmit,
        VoidCallback? ontap,
        String? Function(String?)? onvalidate,
        Function(String?)? onchange,
        String? text,
        Color? textColor,
        Widget? prefixIcon,
        Widget? suffixIcon,
        bool obscure = false,
        InputBorder? border,
        String? hinttext,
        Color? hintcolor,
        Color? cursorColor,
        int? maxligne,
        bool? focus,
        bool readonly = false}) =>
    TextFormField(
        controller: controller,
        keyboardType: inputtype,
        onFieldSubmitted: onfieldsubmit,
        onTap: ontap,
        autofocus: focus ?? false,
        maxLines: maxligne ?? 1,
        readOnly: readonly,
        obscureText: obscure,
        onChanged: onchange,
        cursorColor: cursorColor ?? defaultColor,
        style: TextStyle(
          color: textColor ?? Colors.black,
          fontWeight: FontWeight.normal,
        ),
        decoration: InputDecoration(
          labelText: text,
          hintText: hinttext ?? null,
          hintStyle: TextStyle(color: hintcolor ?? Colors.grey),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          border: border ?? OutlineInputBorder(),
        ),
        validator: onvalidate);
