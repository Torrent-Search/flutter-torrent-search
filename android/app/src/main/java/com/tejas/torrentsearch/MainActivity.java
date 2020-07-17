/*
 *     Copyright (C) 2020 by Tejas Patil <tejasvp25@gmail.com>
 *
 *     torrentsearch_android is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     torrentsearch_android is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with torrentsearch_android.  If not, see <https://www.gnu.org/licenses/>.
 */

package com.tejas.torrentsearch;

import android.database.Cursor;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;

import androidx.annotation.NonNull;

import java.io.File;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

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
                if(call.method.equals("getDownloadDirectory")){
                    if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q){
                        result.success(MediaStore.Audio.Media.getContentUri(MediaStore.VOLUME_EXTERNAL).getPath());
                    }else{
                        File dir = new File(Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MUSIC).getAbsolutePath());
                        if(!dir.exists()){
                            dir.mkdirs();
                        }
                        result.success(dir.getAbsolutePath());
                    }
                }
                if(call.method.equals("isExist")){
                    String[] projection = new String[]{
                            MediaStore.Audio.Media.DISPLAY_NAME,
                    };
                    String selection = MediaStore.Audio.Media.DISPLAY_NAME + " = ?";
                    String[] selectionArgs = new String[] {
                            call.argument("filename")
                    };

                    try{
                        Cursor cursor = getContentResolver().query(MediaStore.Audio.Media.getContentUri(MediaStore.VOLUME_EXTERNAL), projection, selection, selectionArgs, null);
                        final int count = cursor.getCount();
                        cursor.close();
                        result.success(count > 0);
                    }catch (Exception e){
                        result.success(false);
                    }
                }
                if(call.method.equals("isApi29")){
                    result.success(android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.Q);
                }
              }});
  }

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
//    flutterEngine.getPlugins().add(new FirebaseMessagingPlugin());
    GeneratedPluginRegistrant.registerWith(flutterEngine);
  }
}
