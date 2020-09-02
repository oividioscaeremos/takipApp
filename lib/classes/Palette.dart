import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Palette {
  final Color colorPrimary = Color(0xff222831);
  final Color colorSecondary = Color(0xff393e46);
  final Color colorTertiary = Color(0xffb55400);
  final Color colorQuaternary = Color(0xffeeeeee);

  static const CupertinoDynamicColor systemRed =
      CupertinoDynamicColor.withBrightnessAndContrast(
    debugLabel: 'systemRed',
    color: Color.fromARGB(255, 255, 255, 200),
    darkColor: Color.fromARGB(255, 255, 69, 58),
    highContrastColor: Color.fromARGB(255, 215, 50, 21),
    darkHighContrastColor: Color.fromARGB(255, 255, 105, 97),
  );
}
