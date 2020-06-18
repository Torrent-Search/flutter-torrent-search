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
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/network/NetworkProvider.dart';
import 'package:torrentsearch/utils/PreferenceProvider.dart';
import 'package:torrentsearch/widgets/IndexersList.dart';

class Settings extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Settings> {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  String version;
  final List colors0 = [
    Colors.deepPurpleAccent.value,
    Colors.red.value,
    Colors.blue.value
  ];
  final List colors1 = [
    Colors.deepOrange.value,
    Colors.cyan.value,
    Colors.green.value
  ];

  final List colors2 = [
    Color.fromARGB(255, 57, 127, 251).value,
    Color.fromARGB(255, 94, 151, 246).value,
    Colors.yellow.value
  ];

  Future<bool> _init() async {
    version = await getAppVersion();
    return true;
  }

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
      backgroundColor: themeProvider.darkTheme
          ? Theme.of(context).backgroundColor
          : Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'SETTINGS',
          style: TextStyle(letterSpacing: 3.0),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
            color: themeProvider.darkTheme ? Colors.white : Colors.black),
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
              ListTile(
                title: Text(
                  "Dark Mode",
                  style: TextStyle(letterSpacing: 2.0),
                ),
                trailing: Switch(
                  value: themeProvider.darkTheme,
                  activeColor: Theme.of(context).accentColor,
                  onChanged: (bool val) {
                    setState(() {
                      themeProvider.darkTheme = val;
                    });
                  },
                ),
              ),
              ExpansionTile(
                title: Text(
                  "Accent",
                  style: TextStyle(
                    letterSpacing: 2.0,
                  ),
                ),
                trailing: Icon(Icons.keyboard_arrow_down),
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: colors0.map((e) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              themeProvider.accent = e;
                              themeProvider.useSystemAccent = false;
                              themeProvider.preferences.setSystemAccent(false);
                            });
                          },
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Color(e),
                          ),
                        );
                      }).toList()),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: colors1.map((e) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              themeProvider.accent = e;
                              themeProvider.useSystemAccent = false;
                              themeProvider.preferences.setSystemAccent(false);
                            });
                          },
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Color(e),
                          ),
                        );
                      }).toList()),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: colors2.map((e) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              themeProvider.useSystemAccent = false;
                              themeProvider.preferences.setSystemAccent(false);
                              themeProvider.accent = e;
                            });
                          },
                          child: CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Color(e),
                          ),
                        );
                      }).toList()),
                  FutureBuilder(
                      future: deviceInfoPlugin.androidInfo,
                      builder: (BuildContext ctx,
                          AsyncSnapshot<AndroidDeviceInfo> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.version.sdkInt >= 23) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "Use System Accent",
                                    style: TextStyle(letterSpacing: 2.0),
                                  ),
                                  Switch(
                                    value: themeProvider.useSystemAccent,
                                    activeColor: Theme.of(context).accentColor,
                                    onChanged: (bool val) {
                                      setState(() {
                                        themeProvider.preferences
                                            .setSystemAccent(val);
                                        themeProvider.useSystemAccent = val;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
                        }
                        return Container(
                          height: 20.0,
                        );
                      })
                ],
              ),
              ExpansionTile(
                title: Text(
                  "Indexers",
                  style: TextStyle(letterSpacing: 2.0),
                ),
                trailing: Icon(Icons.keyboard_arrow_down),
                children: <Widget>[
                  IndexersList(),
                ],
              ),
              ListTile(
                title: Text("Terms and Conditions",
                    style: TextStyle(letterSpacing: 2.0)),
                trailing: Icon(Icons.description),
                onTap: () {
                  Navigator.pushNamed(context, "/tac");
                },
              ),
              ListTile(
                title: Text("About", style: TextStyle(letterSpacing: 2.0)),
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
}
