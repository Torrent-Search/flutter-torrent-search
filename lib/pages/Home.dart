import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/network/NetworkProvider.dart';
import 'package:torrentsearch/network/exceptions/InternalServerError.dart';
import 'package:torrentsearch/network/exceptions/NoContentFoundException.dart';
import 'package:torrentsearch/network/model/RecentResponse.dart';
import 'package:http/http.dart' as http;
import 'package:torrentsearch/utils/DarkThemeProvider.dart';
import 'package:torrentsearch/widgets/TorrentCard.dart';
import 'package:torrentsearch/widgets/Torrenttab.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeProvider.darkTheme ? Theme.of(context).backgroundColor : Colors.white ,
        body: SingleChildScrollView(
          child: Container(
            width: width,
            height: height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: getSearch(context),
                ),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Recent Movies",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ),
                BuildRecent(context),
                Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Recent TV Shows",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2.0,
                        fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ),
                BuildRecent(context, movies: false),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getSearch(BuildContext ctx) {
//    final double height = MediaQuery.of(ctx).size.height;
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    final double width = MediaQuery.of(ctx).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        TextField(
          controller: _textEditingController,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.all(10.0),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide:
                    BorderSide(color: Colors.deepPurpleAccent, width: 2.0),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
          cursorColor: Colors.deepPurpleAccent,
          keyboardType: TextInputType.text,
          maxLines: 1,
          textAlign: TextAlign.center,
          textInputAction: TextInputAction.search,
          onSubmitted: (term) {
            if (_textEditingController.text != "") {
              Navigator.pushNamed(context, "/result",
                  arguments: _textEditingController.text);
            }
          },
        ),
        SizedBox(
          height: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton.icon(
              label: Text(
                "SEARCH",
                style: TextStyle(
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                if (_textEditingController.text != "") {
                  Navigator.pushNamed(context, "/result",
                      arguments: _textEditingController.text);
                }
              },
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
              color: themeProvider.darkTheme ? Colors.grey : Theme.of(context).accentColor,
            ),
            RaisedButton(
              child: Text(
                "Change Accent",
                style: TextStyle(
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                showDialog(
                  barrierDismissible: true,
                  context: context,
                  child: _buildAccentDialog(context,themeProvider),
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Dark Mode",
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
              ),
            ),
            Switch(
              value: themeProvider.darkTheme,
              activeColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey : Theme.of(context).accentColor,
              onChanged: (bool val){
                setState(() {
                  themeProvider.darkTheme = val;
                });
              },
            )
          ],
        ),
      ],
    );
  }

  Widget BuildRecent(BuildContext ctx, {movies = true}) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final borderRadius = BorderRadius.circular(5);
    return Container(
      height: height * 0.25,
      width: width,
      padding: EdgeInsets.only(left: 5.0),
      child: FutureBuilder<List<RecentInfo>>(
          future: movies ? getRecentMovies() : getRecentSeries(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: snapshot.data.length,
                shrinkWrap: true,
                separatorBuilder: (ctx, index) {
                  return SizedBox(
                    width: 5.0,
                  );
                },
                itemBuilder: (BuildContext ctxt, int index) {
                  return InkWell(
                    onTap: (){
                      Navigator.pushNamed(context, "/recentinfo",arguments: {
                        "imdbcode":snapshot.data[index].imdbcode,
                        "imgurl":snapshot.data[index].imgUrl,
                      });
                    },
                    child: Container(
                      width: width * 0.30,
                      height: height * 0.25,
                      child: Card(
                        shape:
                            RoundedRectangleBorder(borderRadius: borderRadius),
                        child: ClipRRect(
                          borderRadius: borderRadius,
                          child: CachedNetworkImage(
                            fit: BoxFit.fill,
                            imageUrl: snapshot.data[index].imgUrl,
                            progressIndicatorBuilder: (ctx, url, progress) {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Theme.of(context).accentColor),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              switch (snapshot.error.runtimeType) {
                case NoContentFoundException:
                  return noContentFound();
                  break;
                case InternalServerError:
                  return serverError();
                  break;
                case SocketException:
                  return noInternet();
                  break;
                default:
                  return unExpectedError();
              }
            } else {
              return Center(
                  child: SpinKitThreeBounce(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey
                    : Theme.of(context).accentColor,
              ));
            }
          }),
    );
  }
  Widget _buildAccentDialog(BuildContext ctx,provider){
    final width = MediaQuery.of(ctx).size.width;
    final height = MediaQuery.of(ctx).size.height;

    final List colors0 = [Colors.deepPurpleAccent.value,Colors.red.value,Colors.blue.value];
    final List colors1 = [Colors.deepOrange.value,Colors.cyan.value,Colors.green.value];
    return SizedBox(
      width: width * 0.80,
      height: height * 0.50,
      child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: colors0.map((e)  {
                    return InkWell(
                      onTap: (){
                        setState(() {
                          provider.accent = e;
                        });
                        Navigator.pop(ctx);
                      },
                      child: CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Color(e),
                      ),
                    );
                  }).toList()
              ),
              SizedBox(height: 20,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: colors1.map((e)  {
                    return InkWell(
                      onTap: (){
                        setState(() {
                          provider.accent = e;
                        });
                        Navigator.pop(ctx);
                      },
                      child: CircleAvatar(
                        radius: 20.0,
                        backgroundColor: Color(e),
                      ),
                    );
                  }).toList()
              ),
            ],
          )
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }
}
