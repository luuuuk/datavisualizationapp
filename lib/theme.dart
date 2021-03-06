import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeColors {
  static const darkBlue = const Color(0xFF2D274C);
  static const lightBlue = const Color(0xFF165099);
  static const blueGreenis = const Color(0xFF95C4B9);
  static const blueGreenisShade1 = const Color(0xFF688C96);
  static const blueGreenisShade2 = const Color(0xFF76A5AE);
  static const yellowGreenish = const Color(0xFFF6F2CB);
  static const orange = const Color(0xFFF06A25);
  static const darkGrey = const Color(0xFF2E405F);
  static const mediumBlue = const Color(0xFF3A3654);
  static const mediumGrey = const Color(0xFF48475A);
  static const cream = const Color(0xFFF4C789);
  static const altBlueGreen = const Color(0xFF478993);
}


class VisualizationTheme {
  ThemeData theme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: ThemeColors.darkBlue,
    accentColor: ThemeColors.yellowGreenish,

    // Define the default font family.
    fontFamily: 'Montserrat',
    cupertinoOverrideTheme: CupertinoThemeData(
      textTheme: CupertinoTextThemeData(
        dateTimePickerTextStyle:
            TextStyle(color: Colors.white, fontSize: 16),
        pickerTextStyle: TextStyle(color: Colors.white, fontSize: 12),
        primaryColor: ThemeColors.blueGreenisShade1,
      ),
    ),
  );
}

class ActivityInfo {
  static const String activity1Name = "Running";
  static const String activity2Name = "Cycling";
  static const String activity3Name = "Climbing";
  static const String activity4Name = "Hiking";
  static const String activity5Name = "Skiing";

  static const IconData activity1Icon = Icons.directions_run;
  static const IconData activity2Icon = Icons.directions_bike;
  static const IconData activity3Icon = Icons.filter_hdr;
  static const IconData activity4Icon = Icons.directions_walk;
  static const IconData activity5Icon = Icons.ac_unit;
}
