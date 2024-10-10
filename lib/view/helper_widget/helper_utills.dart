import 'package:flutter/material.dart';

BoxDecoration customBoxDecoration({
  Color borderColor =const Color(0xFFDFE3E8),
  Color boxColor = Colors.white,
  double borderRadius = 6,
  double borderWidth = 1.0,
}) {
  return BoxDecoration(
    border: Border.all(
      color: borderColor,
      width: borderWidth,
    ),
    color: boxColor ,
    borderRadius: BorderRadius.circular(borderRadius),
  );
}

