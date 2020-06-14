import 'package:flutter/painting.dart';

class HexColor extends Color {
  HexColor(final String hexColor) : super(getColorFromHex(hexColor));
  static int getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
