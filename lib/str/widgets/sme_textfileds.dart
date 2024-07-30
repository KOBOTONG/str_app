import 'package:flutter/material.dart';

Widget SMETextField({
  TextEditingController? controller,
  required String label,
  IconData? icon,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 32),
    child: TextFormField(
      controller: controller,
      style: TextStyle(
        color: Colors.grey,
      ),
      decoration: InputDecoration(
        labelText: '$label',
        prefixIcon: Icon(
          icon,
          color: Colors.grey,
        ),
        labelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          color: Colors.grey,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    ),
  );
}
