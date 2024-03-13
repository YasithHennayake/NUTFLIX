//imported pakages
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Function to show a toast message
void showToast({required String message}) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 15.0,
  );
}
