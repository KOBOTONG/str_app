import 'package:flutter/material.dart';

MaterialColor primaryColor = const MaterialColor(
  0xFF952124,
   {
    50: Color(0xFFF4D4D5),
    100: Color(0xFFEAB8BA),
    200: Color(0xFFDF9B9E),
    300: Color(0xFFD57F82),
    400: Color(0xFFCB6267),
    500: Color(0xFF952124),
    600: Color(0xFF861E20),
    700: Color(0xFF771A1C),
    800: Color(0xFF681617),
    900: Color(0xFF5A1313),
  },
);
BoxShadow boxShadow = const BoxShadow(
  color: Colors.black12,
  offset: Offset(3, 3),
  blurRadius: 5,
);

BoxShadow transboxShadow = BoxShadow(
  color: Colors.white.withOpacity(0.0),
  offset: Offset(3, 3),
  blurRadius: 5,
);

RoundedRectangleBorder setRoundedBorder(Color bordercolor, double bradius) {
  return RoundedRectangleBorder(
    side: new BorderSide(color: bordercolor, width: 1.0),
    borderRadius: BorderRadius.circular(bradius),
  );
}
