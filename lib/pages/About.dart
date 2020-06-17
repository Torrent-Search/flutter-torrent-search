import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/utils/PreferenceProvider.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<PreferenceProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: themeProvider.darkTheme
          ? Theme.of(context).backgroundColor
          : Colors.white,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
                height: height * 0.20,
                child: Image.asset("assets/app_logo.png")),
            SizedBox(
              height: 15.0,
            ),
            Text(
              "Torrent Search",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25.0,
                  letterSpacing: 1.5),
            ),
            SizedBox(height: 25.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                "Torrent Search is an Open Source app written in Flutter, It uses Crawler technology to scrap multiple Torrent Websites, Working principle similar to browser, content parsing from DHT(Distributed Hash Table) protocol based Bittorrent resource search engine website. All the resources are scraped by Crawler API (https://github.com/Tejasvp25/torr_scraper_golang) written in Golang",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 17.0),
              ),
            ),
            SizedBox(height: 25),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                  EmojiParser()
                      .emojify("Made with :heart: in India\nBy Tejasvp25"),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "OpenSans",
                      letterSpacing: 1.5,
                      fontSize: 17.0)),
            ),
            FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (BuildContext ctx, AsyncSnapshot<PackageInfo> snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    "V ${snapshot.data.version}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        fontSize: 17.0),
                  );
                }
                return Container(
                  height: 0.0,
                  width: 0.0,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
