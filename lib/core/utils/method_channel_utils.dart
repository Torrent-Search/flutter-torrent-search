import 'dart:ui';

import 'package:torrentsearch/core/constants.dart';

class MethodChannelUtils {
  ///* Invokes the [Constants.METHOD_CLIPBOARD] method
  /// Copies the [str] to device clipboard
  static Future<void> copyToClipboard(String str) async {
    await Constants.METHOD_CHANNEL
        .invokeMethod(Constants.METHOD_CLIPBOARD, {"text": str});
    return;
  }

  ///* Invokes the [Constants.METHOD_SHARE] method
  /// Opens natice share chosser for [str]
  static Future<void> share(String str) async {
    await Constants.METHOD_CHANNEL
        .invokeMethod(Constants.METHOD_SHARE, {"text": str});
    return;
  }

  ///* Invokes the [Constants.METHOD_SYSTEM_ACCENT] method
  ///! Works only for Android API 23+
  static Future<int> getSystemAccent() async {
    final Color fromChannel = Color(await Constants.METHOD_CHANNEL
        .invokeMethod(Constants.METHOD_SYSTEM_ACCENT));
    final Color compatilbleToFlutter = Color.fromRGBO(
        fromChannel.red, fromChannel.green, fromChannel.blue, 1.0);

    return compatilbleToFlutter.value;
  }

  ///* Invokes the [Constants.METHOD_OPEN_LINK] method
  /// Opens the [str] in Browser
  static Future<void> openLink(String str) async {
    await Constants.METHOD_CHANNEL
        .invokeMethod(Constants.METHOD_OPEN_LINK, {"text": str});
    return;
  }

  ///* Invokes the [Constants.METHOD_SDK_INT] method
  ///* Returns [Android SDK] int
  static Future<int> getSdkInt() async {
    return Constants.METHOD_CHANNEL.invokeMethod(Constants.METHOD_SDK_INT);
  }

  ///* Invokes the [Constants.METHOD_APP_VERSION] method
  ///* Returns [App Version] int
  static Future<String> getVersion() async {
    return Constants.METHOD_CHANNEL.invokeMethod(Constants.METHOD_APP_VERSION);
  }
}
