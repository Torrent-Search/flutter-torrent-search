import 'dart:ui';

import 'package:torrentsearch/core/constants.dart';

class MethodChannelUtils {
  static Future<void> copyToClipboard(String str) async {
    await Constants.METHOD_CHANNEL
        .invokeMethod(Constants.METHOD_CLIPBOARD, {"text": str});
    return;
  }

  static Future<void> share(String str) async {
    await Constants.METHOD_CHANNEL
        .invokeMethod(Constants.METHOD_SHARE, {"text": str});
    return;
  }

  static Future<int> getSystemAccent() async {
    final Color fromChannel = Color(await Constants.METHOD_CHANNEL
        .invokeMethod(Constants.METHOD_SYSTEM_ACCENT));
    final Color compatilbleToFlutter = Color.fromRGBO(
        fromChannel.red, fromChannel.green, fromChannel.blue, 1.0);

    return compatilbleToFlutter.value;
  }

  static Future<void> openLink(String str) async {
    await Constants.METHOD_CHANNEL
        .invokeMethod(Constants.METHOD_OPEN_LINK, {"text": str});
    return;
  }

  static Future<int> getSdkInt() async {
    return Constants.METHOD_CHANNEL.invokeMethod(Constants.METHOD_SDK_INT);
  }

  static Future<String> getVersion() async {
    return Constants.METHOD_CHANNEL.invokeMethod(Constants.METHOD_APP_VERSION);
  }
}
