import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

void showFlushBar(BuildContext context, String msg) {
  Flushbar(
    message: msg,
    showProgressIndicator: true,
    onTap: (flushbar) => flushbar.dismiss(),
    isDismissible: true,
    duration: const Duration(seconds: 3),
  ).show(context);
}
