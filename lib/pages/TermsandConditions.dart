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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/utils/PreferenceProvider.dart';

class TermsandConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PreferenceProvider>(context);
    final Color accentColor = Theme.of(context).accentColor;
    return Scaffold(
      backgroundColor:
          provider.darkTheme ? Theme.of(context).backgroundColor : Colors.white,
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Container(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                Flexible(
                  child: ListView(
                    shrinkWrap: false,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Text(
                        "Terms & Conditions",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildMultiplineText(context,
                          "By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy, or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages. The app itself, and all the trade marks, copyright, database rights and other intellectual property rights related to it, still belong to Developer."),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildMultiplineText(context,
                          "Developer is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for."),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildMultiplineText(context,
                          "You should be aware that there are certain things that Developer will not take responsibility for. Certain functions of the app will require the app to have an active internet connection. The connection can be Wi-Fi, or provided by your mobile network provider, but Developer cannot take responsibility for the app not working at full functionality if you don’t have access to Wi-Fi, and you don’t have any of your data allowance left."),
                      SizedBox(
                        height: 30.0,
                      ),
                      Center(
                        child: Text(
                          "Changes to This Terms and Conditions",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                      ),
                      _buildMultiplineText(context,
                          "I may update our Terms and Conditions from time to time. Thus, you are advised to review this page periodically for any changes. I will notify you of any changes by posting the new Terms and Conditions on this page.These terms and conditions are effective as of 2020-06-17"),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        "Contact Us",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                        textAlign: TextAlign.start,
                      ),
                      _buildMultiplineText(context,
                          "If you have any questions or suggestions about my Terms and Conditions, do not hesitate to contact me at tejasvp25@gmail.com"),
                      SizedBox(
                        height: 30.0,
                      ),
                      Text(
                        "Disclaimer",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0,
                            color: Colors.red),
                      ),
                      _buildMultiplineText(context,
                          "All the content generated by Software comes from the Internet. The Application is not responsible or liable for the validity and authenticity of the content, such as disputes. Contact the source website for processing",
                          color: Colors.red),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildMultiplineText(context,
                          "This application uses Crawler technology to integrate resources from internet, into the App. Convenient search and find, Only for learning materials, films and television entertainment, Pleas use it reasonably. It's forbidden to use P2P technology in some countries and regions. Do not use this application."),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildMultiplineText(context,
                          "All links(Magnet links) of this application are collected from network, no resources files are stored, no resources are downloaded. If the internet infringment issues are involved, please contact the source website and the developer does not assume any legal responsibility",
                          color: Colors.red),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                provider.tacaccepted
                    ? Container(
                        height: 0.0,
                        width: 0.0,
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          FlatButton(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: accentColor,
                                  width: 2.0,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            onPressed: () async {
                              provider.tacaccepted = true;
                              Navigator.pushReplacementNamed(context, "/home");
                            },
                            child: Text("ACCEPT"),
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: accentColor,
                                  width: 2.0,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            onPressed: () {
                              exit(0);
                            },
                            child: Text("REFUSE"),
                          ),
                        ],
                      )
              ],
            )),
      ),
    );
  }

  Widget _buildMultiplineText(BuildContext ctx, String msg,
      {Color color = Colors.black}) {
    final Brightness br = Theme.of(ctx).brightness;
    if (color == Colors.black) {
      color = br == Brightness.dark ? Colors.white : Colors.black;
    }
    return Text(msg,
        style: TextStyle(fontSize: 14.0, color: color),
        maxLines: 20,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.justify);
  }
}
