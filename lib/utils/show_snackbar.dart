import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Add fluttertoast dependency
import 'dart:io' show Platform;

class AppNotification {
  static void showNotification(BuildContext context, String message, {Color backgroundColor = Colors.grey}) {
    if (Platform.isAndroid) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
        ),
      );
    } else if (Platform.isIOS) {
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: backgroundColor,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  static void showSuccessNotification(BuildContext context, String message) {
    showNotification(context, message, backgroundColor: Colors.green);
  }

  static void showErrorNotification(BuildContext context, String message) {
    showNotification(context, message, backgroundColor: Colors.red);
  }

  static void showWarningNotification(BuildContext context, String message) {
    showNotification(context, message, backgroundColor: Colors.orange);
  }

  static void showInfoNotification(BuildContext context, String message) {
    showNotification(context, message, backgroundColor: Colors.blue);
  }
}
