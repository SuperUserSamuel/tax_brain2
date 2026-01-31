import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform; // Import Platform for OS detection

class AppNavigation {
  /// Navigate to a new screen using push.
  static void push(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      Platform.isIOS
          ? CupertinoPageRoute(builder: (context) => screen)
          : MaterialPageRoute(builder: (context) => screen),
    );
  }

  /// Navigate to a new screen using pushReplacement.
  static void pushReplacement(BuildContext context, Widget screen) {

    Navigator.pushReplacement(
      context,
      Platform.isIOS
          ? CupertinoPageRoute(builder: (context) => screen)
          : MaterialPageRoute(builder: (context) => screen),
    );
  }

  /// Navigate to a new screen using pushAndRemoveUntil.
  static void pushAndRemoveUntil(BuildContext context, Widget screen, String routeName) {

    Navigator.pushAndRemoveUntil(
      context,
      Platform.isIOS
          ? CupertinoPageRoute(builder: (context) => screen)
          : MaterialPageRoute(builder: (context) => screen),
          (Route<dynamic> route) => route.settings.name == routeName,
    );
  }

  /// Pop the current screen.
  static void pop(BuildContext context, [result]) {
    Navigator.pop(context, result);
  }

  /// Pop until a specific route name.
  static void popUntil(BuildContext context, String routeName) {
    Navigator.popUntil(context, ModalRoute.withName(routeName));
  }

  /// Check if the current route can be popped.
  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  /// Go back to the first screen (root).
  static void popToRoot(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  ///Navigate using named routes
  static void pushNamed(BuildContext context, String routeName, {Object? arguments}){
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  ///Replace the current route with a named route.
  static void pushReplacementNamed(BuildContext context, String routeName, {Object? arguments}){
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  ///Push a named route and remove all previous routes.
  static void pushNamedAndRemoveUntil(BuildContext context, String routeName, String predicateRouteName, {Object? arguments}){
    Navigator.pushNamedAndRemoveUntil(context, routeName, ModalRoute.withName(predicateRouteName), arguments: arguments);
  }

}