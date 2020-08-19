import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:torrentsearch/core/utils/preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    /// Call [decideRoute] after 2 Seconds
    Timer(const Duration(seconds: 2), () => decideRoute(context));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.20,
                child: Image.asset("assets/app_logo.png"),
              ),
              CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation(Theme.of(context).accentColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Decide which Screen To Show Depending of the Terms and Condition Statues [tacStatus]
  void decideRoute(BuildContext context) {
    final bool tac = Preferences.tacStatus();
    if (tac) {
      ExtendedNavigator.of(context).popAndPush("/home");
    } else {
      ExtendedNavigator.of(context).popAndPush("/tac");
    }
  }
}
