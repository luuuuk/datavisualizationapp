import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeColors {
  static const darkBlue = const Color(0xFF2D274C);
  static const lightBlue = const Color(0xFF306FA5);
  static const blueGreenis = const Color(0xFF95C4B9);
  static const blueGreenisShade1 = const Color(0xFF5E6A77);
  static const blueGreenisShade2 = const Color(0xFF657288);
  static const yellowGreenish = const Color(0xFFF6F2CB);
  static const orange = const Color(0xFFF06A25);
}

class VisualizationTheme {
  ThemeData theme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: ThemeColors.darkBlue,
    accentColor: ThemeColors.yellowGreenish,

    // Define the default font family.
    fontFamily: 'Roboto',
    cupertinoOverrideTheme: CupertinoThemeData(
      textTheme: CupertinoTextThemeData(
        dateTimePickerTextStyle:
            TextStyle(color: ThemeColors.orange, fontSize: 16),
        pickerTextStyle: TextStyle(color: Colors.white, fontSize: 12),
      ),
    ),
  );
}
