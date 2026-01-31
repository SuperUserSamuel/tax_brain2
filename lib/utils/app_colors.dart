import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // prevent instantiation

  /// Background color: black in dark mode, white in light mode
  static Color bgColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white;

  /// Title text: white in dark, black in light
  static Color titleColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black;

  /// Semi‐transparent white or black depending on mode
  static Color transparentWhite(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white54
          : Colors.white30;

  static Color transparentWhite2(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white30
          : Colors.white;

  static Color transparentBlack(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.black54
          : Colors.black26;

  /// Accent colors don’t usually change with theme, but you can if you like
  static const Color orange = Colors.orangeAccent;
  static const Color green = Colors.green;

  /// A “full background black” vs. light grey in light mode
  static Color fullBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[900]!
          : Colors.grey[200]!;

  /// App bar background
  static Color appBarBackground(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : Colors.white;
}
