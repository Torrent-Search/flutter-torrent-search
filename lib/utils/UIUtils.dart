import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showFlushBar(BuildContext context, String msg) {
  Flushbar(
    message: msg,
    duration: Duration(seconds: 4),
    flushbarStyle: FlushbarStyle.FLOATING,
  ).show(context);
}
