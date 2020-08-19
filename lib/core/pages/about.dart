import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:torrentsearch/core/utils/method_channel_utils.dart';
import 'package:torrentsearch/main.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final TextStyle textStyle = Theme.of(context).textTheme.subtitle1.copyWith(
          letterSpacing: 1.5,
          fontSize: 15.0,
        );
    final TextStyle textStyleWithColor =
        Theme.of(context).textTheme.subtitle1.copyWith(
              letterSpacing: 1.5,
              fontSize: 15.0,
              color: Colors.deepPurple,
            );

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: <Widget>[
            const SliverAppBar(
              title: Text("About"),
              centerTitle: true,
              floating: true,
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                      height: height * 0.15,
                      child: Image.asset("assets/app_logo.png")),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Text(
                    "Torrent Search and Music Search/Download",
                    textAlign: TextAlign.center,
                    style: textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 25.0,
                    ),
                  ),
                  Text(
                    "V ${MyApp.appVersion}\n By Tejasvp25",
                    textAlign: TextAlign.center,
                    style: textStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: <InlineSpan>[
                        TextSpan(
                          text:
                              "Torrent Search is an Open Source app written in Flutter  (",
                          style: textStyle,
                        ),
                        TextSpan(
                          text:
                              "https://github.com/Torrent-Search/flutter-torrent-search",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              MethodChannelUtils.openLink(
                                  "https://github.com/Torrent-Search/flutter-torrent-search");
                            },
                          style: textStyleWithColor,
                        ),
                        TextSpan(
                          text:
                              "), It uses Crawler technology to scrap multiple Torrent Websites for Torrents, Working principle similar to browser, content parsing from DHT(Distributed Hash Table) protocol based Bittorrent resource search engine website. All the resources are scraped by RESTful Crawler API (",
                          style: textStyle,
                        ),
                        TextSpan(
                          text:
                              "https://github.com/Torrent-Search/torr_scraper_golang",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              MethodChannelUtils.openLink(
                                  "https://github.com/Torrent-Search/torr_scraper_golang");
                            },
                          style: textStyleWithColor,
                        ),
                        TextSpan(
                          text: ") written in Golang",
                          style: textStyle,
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 25),
                  ExpansionTile(
                    title: styledText("Credits", context),
                    children: <Widget>[
                      ListTile(
                        title: styledText("Downloader - 0.0.1", context),
                        subtitle:
                            styledText("By Git-Ashwin", context, bold: false),
                      ),
                      ListTile(
                        title: styledText("Firebase", context),
                        subtitle: styledText("By Google", context, bold: false),
                      ),
                      ListTile(
                        title: styledText("Shared Preference", context),
                        subtitle: styledText("By Flutter Community", context,
                            bold: false),
                      ),
                      ListTile(
                        title: styledText("Sqflite", context),
                        subtitle:
                            styledText("By tekartik", context, bold: false),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 10.0),
                    child: Text(
                      EmojiParser()
                          .emojify("Made with :heart: in India\nBy Tejasvp25"),
                      textAlign: TextAlign.center,
                      style: textStyle.copyWith(fontSize: 17.0),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  ///* Returns [Text] According to Given Parameters
  /// @param [msg] String to be Displayed
  /// @param [content] Build Context
  /// @param [bold] String should be bold or not
  Text styledText(String msg, BuildContext context, {bool bold = true}) {
    final TextStyle textStyle = Theme.of(context).textTheme.subtitle1.copyWith(
          letterSpacing: 1.5,
          fontSize: 15.0,
        );
    return Text(
      msg,
      style: bold
          ? textStyle
          : textStyle.copyWith(
              fontWeight: FontWeight.normal,
            ),
    );
  }
}
