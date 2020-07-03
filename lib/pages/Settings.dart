/*
 *     Copyright (C) 2020 by Tejas Patil <tejasvp25@gmail.com>
 *
 *     torrentsearch is free software: you can redistribute it and/or modify
 *     it under the terms of the GNU General Public License as published by
 *     the Free Software Foundation, either version 3 of the License, or
 *     (at your option) any later version.
 *
 *     torrentsearch is distributed in the hope that it will be useful,
 *     but WITHOUT ANY WARRANTY; without even the implied warranty of
 *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *     GNU General Public License for more details.
 *
 *     You should have received a copy of the GNU General Public License
 *     along with torrentsearch.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:device_info/device_info.dart';
import 'package:downloader/downloader.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/network/NetworkProvider.dart';
import 'package:torrentsearch/network/model/Update.dart';
import 'package:torrentsearch/utils/PreferenceProvider.dart';
import 'package:torrentsearch/widgets/IndexersList.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Settings> {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String version;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<PreferenceProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'SETTINGS',
          style: TextStyle(
            letterSpacing: 3.0,
            fontFamily: "OpenSans",
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          height: height,
          width: width,
          child: ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            children: <Widget>[
              _buildDecoration(themeProvider),
              ExpansionTile(
                title: Text(
                  "Indexers",
                  style: TextStyle(
                    letterSpacing: 2.0,
                    fontFamily: "OpenSans",
                  ),
                ),
                trailing: Icon(Icons.keyboard_arrow_down),
                children: <Widget>[
                  IndexersList(),
                ],
              ),
              ListTile(
                title: Text("Terms and Conditions",
                    style: TextStyle(
                      letterSpacing: 2.0,
                      fontFamily: "OpenSans",
                    )),
                trailing: Icon(Icons.description),
                onTap: () {
                  Navigator.pushNamed(context, "/tac");
                },
              ),
              ListTile(
                title: Text(
                  "Join our Telegram Channel",
                  style: TextStyle(
                    letterSpacing: 2.0,
                    fontFamily: "OpenSans",
                  ),
                ),
                subtitle: Text(
                  "Torrent Search",
                  style: TextStyle(
                    letterSpacing: 2.0,
                    fontFamily: "OpenSans",
                  ),
                ),
                trailing: Icon(Icons.send),
                onTap: () {
                  launch("https://t.me/torrentsearch_app");
                },
              ),
              FutureBuilder(
                future: PackageInfo.fromPlatform(),
                builder: (BuildContext context,
                    AsyncSnapshot<PackageInfo> snapshot) {
                  if (snapshot.hasData) {
                    return FutureBuilder(
                      future: getAppVersion(
                          Provider.of<PreferenceProvider>(context).baseUrl),
                      builder: (BuildContext context,
                          AsyncSnapshot<Update> snapshoti) {
                        if (snapshoti.hasData) {
                          if (snapshot.data.version
                                  .compareTo(snapshoti.data.version) ==
                              -1) {
                            return ExpansionTile(
                              title: Text(
                                "Update",
                                style: TextStyle(letterSpacing: 2.0),
                              ),
                              trailing: Icon(Icons.keyboard_arrow_down),
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      Center(
                                        child: Text(
                                          "New Update Available : ${snapshoti.data.version}",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 2.0,
                                            fontFamily: "OpenSans",
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Downloader.download(
                                              snapshoti.data.link,
                                              "Torrent_Search_${snapshoti.data.version}",
                                              ".apk");
                                          Flushbar(
                                            message:
                                                "Downloading Update to Downloads",
                                            duration: Duration(seconds: 3),
                                            flushbarStyle:
                                                FlushbarStyle.FLOATING,
                                          ).show(context);
                                        },
                                        icon: Icon(Icons.file_download),
                                        color: Theme.of(context).accentColor,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }
                        }
                        return Container(
                          height: 0.0,
                          width: 0.0,
                        );
                      },
                    );
                  }
                  return Container(
                    height: 0.0,
                    width: 0.0,
                  );
                },
              ),
              ListTile(
                title: Text("About",
                    style: TextStyle(
                      letterSpacing: 2.0,
                      fontFamily: "OpenSans",
                    )),
                trailing: Icon(Icons.info_outline),
                onTap: () {
                  Navigator.pushNamed(context, "/about");
                },
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    EmojiParser().emojify("Made with :heart: in India"),
                    style: TextStyle(
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: "OpenSans",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDecoration(PreferenceProvider provider) {
    return ExpansionTile(
      title: Text(
        "Decoration",
        style: TextStyle(letterSpacing: 2.0),
      ),
      children: <Widget>[
        Container(
          child: MaterialColorPicker(
            allowShades: true,
            selectedColor: Color(provider.accent),
            onlyShadeSelection: true,
            onColorChange: (Color c) {
              provider.useSystemAccent = false;
              provider.accent = c.value;
            },
            shrinkWrap: true,
          ),
        ),
        SwitchListTile(
          title: Text(
            "Dark Mode",
            style: TextStyle(letterSpacing: 1.0),
          ),
          value: provider.darkTheme,
          activeColor: Theme.of(context).accentColor,
          onChanged: (bool val) {
            setState(() {
              provider.darkTheme = val;
            });
          },
        ),
        FutureBuilder(
            future: deviceInfoPlugin.androidInfo,
            builder:
                (BuildContext ctx, AsyncSnapshot<AndroidDeviceInfo> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.version.sdkInt >= 23) {
                  return SwitchListTile(
                    title: Text(
                      "Use System Accent",
                      style: TextStyle(letterSpacing: 2.0),
                    ),
                    value: provider.useSystemAccent,
                    activeColor: Theme.of(context).accentColor,
                    onChanged: (bool val) {
                      setState(() {
                        provider.preferences.setSystemAccent(val);
                        provider.useSystemAccent = val;
                      });
                    },
                  );
                }
              }
              return Container(
                height: 20.0,
              );
            }),
      ],
    );
  }
}
