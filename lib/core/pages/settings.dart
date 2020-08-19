import 'package:auto_route/auto_route.dart';
import 'package:downloader/downloader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:torrentsearch/core/bloc/styles_bloc.dart';
import 'package:torrentsearch/core/utils/method_channel_utils.dart';
import 'package:torrentsearch/core/utils/preferences.dart';
import 'package:torrentsearch/core/utils/update.dart';
import 'package:torrentsearch/features/torrent/data/datasources/torrent_api_source.dart';
import 'package:torrentsearch/injector.dart';
import 'package:torrentsearch/main.dart';

class Settings extends StatefulWidget {
  const Settings();

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Settings> {
  String version;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    /// subtitle1[TextStyle] with Letter Spacing 2.0
    final TextStyle textStyle =
        Theme.of(context).textTheme.subtitle1.copyWith(letterSpacing: 2.0);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'SETTINGS',
          style: textStyle.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 3.0,
          ),
        ),
        centerTitle: true,
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
            children: <Widget>[
              _buildDecoration(),
              ListTile(
                title: Text(
                  "Terms and Conditions",
                  style: textStyle,
                ),
                trailing: const Icon(Icons.description),
                onTap: () {
                  ExtendedNavigator.of(context).push("/tac");
                },
              ),
              ListTile(
                title: Text(
                  "Join our Telegram Channel",
                  style: textStyle,
                ),
                subtitle: const Text(
                  "Torrent Search",
                ),
                trailing: const Icon(Icons.send),
                onTap: () {
                  MethodChannelUtils.openLink("https://t.me/torrentsearch_app");
                },
              ),
              _buildUpdateTile(),
              ListTile(
                title: Text(
                  "About",
                  style: textStyle,
                ),
                trailing: const Icon(Icons.info_outline),
                onTap: () {
                  ExtendedNavigator.of(context).push("/about");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///* Return [ExpansionTile] with Accent Color Picker and Dark Mode Switch
  Widget _buildDecoration() {
    final TextStyle textStyle =
        Theme.of(context).textTheme.subtitle1.copyWith(letterSpacing: 2.0);
    return BlocBuilder<StylesBloc, StylesState>(
      bloc: BlocProvider.of<StylesBloc>(context),
      builder: (BuildContext context, StylesState state) {
        return ExpansionTile(
          title: Text(
            "Decoration",
            style: textStyle,
          ),
          children: <Widget>[
            Container(
              child: MaterialColorPicker(
                selectedColor: BlocProvider.of<StylesBloc>(context)
                    .state
                    .themeData
                    .accentColor,
                onlyShadeSelection: true,
                onColorChange: (Color c) {
                  final StylesState state =
                      BlocProvider.of<StylesBloc>(context).state;
                  BlocProvider.of<StylesBloc>(context).add(
                    StylesEvent(
                      darkMode:
                          state is StylesDarkModeState ? state.darkMode : false,
                      colorCode: c.value,
                    ),
                  );
                  Preferences.setAccentCode(c.value);
                },
                shrinkWrap: true,
              ),
            ),
            SwitchListTile(
              title: Text(
                "Night Mode",
                style: textStyle,
              ),
              value: state.darkMode,
              onChanged: (val) {
                BlocProvider.of<StylesBloc>(context).add(
                  StylesEvent(
                    darkMode: val,
                    colorCode: state.themeData.accentColor.value,
                  ),
                );
                Preferences.setNightMode(nightMode: val);
              },
              activeColor: Theme.of(context).accentColor,
            )
          ],
        );
      },
    );
  }

  ///* Returns [FutureBuilder]
  /// Compares Current App Version with The Latest Vaersion
  /// Code Obtained From Server
  /// Renders [ExpansionTile] if Latest Version is Available
  /// Otherwise Renders [Container]
  Widget _buildUpdateTile() {
    final TextStyle textStyle =
        Theme.of(context).textTheme.subtitle1.copyWith(letterSpacing: 2.0);
    return FutureBuilder(
      future: getAppVersion(sl<TorrentApiDataSource>().getBaseUrl()),
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.hasData &&
            MyApp.appVersion.compareTo(snapshot.data["version"].toString()) ==
                -1) {
          return ExpansionTile(
            title: Text(
              "Update",
              style: textStyle,
            ),
            trailing: const Icon(Icons.keyboard_arrow_down),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Center(
                      child: Text(
                        "New Update Available : ${snapshot.data["version"]}",
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Downloader.download(
                            snapshot.data["link"].toString(),
                            "Torrent_Search_${snapshot.data["version"]}",
                            ".apk");
                      },
                      icon: const Icon(Icons.file_download),
                      color: Theme.of(context).accentColor,
                    )
                  ],
                ),
              ),
            ],
          );
        }

        return Container();
      },
    );
  }
}
