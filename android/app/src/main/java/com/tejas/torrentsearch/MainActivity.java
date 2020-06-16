package com.tejas.torrentsearch;

import android.annotation.TargetApi;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.util.TypedValue;
import android.view.ContextThemeWrapper;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin;

public class MainActivity extends FlutterActivity {
  private static final String CHANNEL = "flutter.native/helper";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                if (call.method.equals("getSystemAccent")) {
                    int color = 0;
                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
                        color = getColor(R.color.systemaccent);
                    }else{
                        color = 8146431;
                    }
                    result.success(color);
                }
              }});
  }

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
//    flutterEngine.getPlugins().add(new FirebaseMessagingPlugin());
    GeneratedPluginRegistrant.registerWith(flutterEngine);
  }
}
