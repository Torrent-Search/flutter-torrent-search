import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:torrentsearch/utils/Preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () async => decideRoute(context));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
                height: MediaQuery.of(context).size.height * 0.20,
                child: Image.asset("assets/app_logo.png")),
            SpinKitThreeBounce(color: Theme.of(context).accentColor),
          ],
        ),
      ),
    );
  }

  Future<void> decideRoute(BuildContext context) async {
    final Preferences pref = Preferences();
    bool tac = await pref.getTacAccepted();
    if (tac) {
      Navigator.pushReplacementNamed(context, "/home");
    } else {
      Navigator.pushReplacementNamed(context, "/tac");
    }
  }
}
