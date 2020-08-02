package com.tejas.torrentsearch;

import android.annotation.TargetApi;
import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.tejas.torrentsearch";
    private ClipboardManager mClipboardManager;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        getApplicationContext();
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
            mClipboardManager = (ClipboardManager) getApplicationContext().getSystemService(CLIPBOARD_SERVICE);
        }

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(new MethodChannel.MethodCallHandler() {

                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {

                        if (call.method.equals("getSystemAccent")) {
                            int color = 0;
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                                color = getColor(R.color.systemaccent);
                                System.out.println(color);
                            } else {
                                color = getResources().getColor(R.color.systemaccent);
                            }
                            result.success(color);
                        }
                        if (call.method.equals("copyToClipboard")) {
                            final String textToCopy = call.argument("text");
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB) {
                                final ClipData clipData = ClipData.newPlainText("", textToCopy);
                                mClipboardManager.setPrimaryClip(clipData);
                                result.success(true);
                            }else {
                                result.error("Cannot Copy to Clipboard",null,null);
                            }
                        }
                        if (call.method.equals("share")) {

                            try{
                                final String textToShare = call.argument("text");
                                Intent intent = new Intent();
                                intent.setAction(Intent.ACTION_SEND);
                                intent.setType("text/plain");
                                intent.putExtra(Intent.EXTRA_TEXT,textToShare);
                                startActivity(Intent.createChooser(intent,"Share Magnet Link"));
                                result.success(true);
                            }catch(Exception e){
                                result.error(e.getMessage(),null,null);
                            }
                        }
                        if (call.method.equals("openLink")){
                            try{
                                final String link = call.argument("text");
                                Intent intent = new Intent();
                                intent.setAction(Intent.ACTION_VIEW);
                                intent.setData(Uri.parse(link));
                                startActivity(intent);
                                result.success(true);
                            }catch(Exception e){
                                result.error(e.getMessage(),null,null);
                            }
                        }
                        if (call.method.equals("getSdkInt")){
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.DONUT) {
                                result.success(Build.VERSION.SDK_INT);
                            }
                        }
                        if (call.method.equals("getVersion")){
                            try {
                                final PackageInfo packageInfo = getPackageManager().getPackageInfo(getApplicationContext().getPackageName(),0);
                                result.success(packageInfo.versionName);
                            } catch (PackageManager.NameNotFoundException e) {
                                result.error(e.getMessage(),null,null);
                            }
                        }
                    }
                });

    }

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
    }
}
