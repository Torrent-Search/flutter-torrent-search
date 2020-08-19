import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:torrentsearch/core/utils/preferences.dart';

class TermsandConditions extends StatelessWidget {
  const TermsandConditions();

  @override
  Widget build(BuildContext context) {
//    final bool nightMode = Provider.of<PreferenceProvider>(context);
    final Color accentColor = Theme.of(context).accentColor;
    final TextStyle textStyle = Theme.of(context).textTheme.subtitle1.copyWith(
          letterSpacing: 1.5,
          fontSize: 15.0,
          color: accentColor,
        );
    final RoundedRectangleBorder buttonShape = RoundedRectangleBorder(
      side: BorderSide(
        color: accentColor,
        width: 2.0,
      ),
      borderRadius: BorderRadius.circular(10.0),
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                  title: Text("Terms and Conditions",
                      style: Theme.of(context).textTheme.headline6),
                  centerTitle: true,
                  floating: true,
                ),
                SliverPadding(
                  padding: const EdgeInsets.all(20.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      <Widget>[
                        _buildMultiplineText(context,
                            "By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy, or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages. The app itself, and all the trade marks, copyright, database rights and other intellectual property rights related to it, still belong to Developer."),
                        const SizedBox(height: 10.0),
                        _buildMultiplineText(context,
                            "Developer is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for."),
                        const SizedBox(height: 10.0),
                        _buildMultiplineText(context,
                            "You should be aware that there are certain things that Developer will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi, or provided by your mobile network provider, but Developer cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left."),
                        const SizedBox(height: 30.0),
                        Center(
                          child: Text(
                            "Changes to This Terms and Conditions",
                            textAlign: TextAlign.start,
                            style: textStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              letterSpacing: 0.25,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        _buildMultiplineText(context,
                            "I may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Terms and Conditions on this page.These terms and conditions are effective as of 2020-06-17"),
                        const SizedBox(height: 30.0),
                        Text(
                          "Contact Us",
                          style: textStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            letterSpacing: 0.25,
                          ),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: 10.0),
                        _buildMultiplineText(context,
                            "If you have any questions or suggestions about my Terms and Conditions, do not hesitate to contact me at tejasvp25@gmail.com"),
                        const SizedBox(height: 30.0),
                        Text(
                          "Disclaimer",
                          textAlign: TextAlign.start,
                          style: textStyle.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                              letterSpacing: 0.25,
                              color: Colors.red),
                        ),
                        const SizedBox(height: 10.0),
                        _buildMultiplineText(context,
                            "All the content generated by Software comes from the Internet. The Application is not responsible or liable for the validity and authenticity of the content, such as disputes. Contact the source website for processing",
                            color: Colors.red),
                        const SizedBox(height: 10.0),
                        _buildMultiplineText(context,
                            "This application uses Crawler technology to integrate resources from internet, into the App. Convenient search and find, Only for learning materials, films and television entertainment, Please use it reasonably. It's forbidden to use P2P technology in some countries and regions. Do not use this application."),
                        const SizedBox(height: 10.0),
                        _buildMultiplineText(context,
                            "All links(Magnet links) of this application are collected from network, no resources files are stored, no resources are downloaded. If the internet infringment issues are involved, please contact the source website and the developer does not assume any legal responsibility",
                            color: Colors.red),
                        const SizedBox(
                          height: 40.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Preferences.tacStatus()
                  ? Container(
                      height: 0.0,
                      width: 0.0,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        FlatButton(
                          shape: buttonShape,
                          onPressed: () {
                            Preferences.setTacStatus(true);
                            Navigator.pushReplacementNamed(context, "/home");
                          },
                          child: const Text("ACCEPT"),
                        ),
                        FlatButton(
                          shape: buttonShape,
                          onPressed: () {
                            exit(0);
                          },
                          child: const Text("REFUSE"),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  ///* Return [Text] depending on given [msg] string and [color] color
  /// if [color] is null Derive color from [Theme.brightness]
  Widget _buildMultiplineText(BuildContext ctx, String msg, {Color color}) {
    if (color == null) {
      final Brightness br = Theme.of(ctx).brightness;
      // ignore: parameter_assignments
      color = br == Brightness.dark ? Colors.white : Colors.black;
    }
    return Text(msg,
        style: TextStyle(fontSize: 14.0, color: color, fontFamily: "OpenSans"),
        maxLines: 20,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.justify);
  }
}
