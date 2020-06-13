import 'dart:convert';
import 'dart:io';
import 'package:intent/intent.dart' as android_intent;
import 'package:intent/action.dart' as android_action;
import 'package:intent/extra.dart' as android_extra;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/network/exceptions/InternalServerError.dart';
import 'package:torrentsearch/network/exceptions/NoContentFoundException.dart';
import 'package:torrentsearch/network/model/Imdb.dart';
import 'package:torrentsearch/network/model/TorrentInfo.dart';
import 'package:torrentsearch/network/model/TorrentRepo.dart';
import 'package:torrentsearch/utils/DarkThemeProvider.dart';
import 'package:torrentsearch/widgets/TorrentCard.dart';
import 'package:torrentsearch/widgets/Torrenttab.dart';
import 'package:http/http.dart' as http;

class RecentInfo extends StatefulWidget {
  @override
  _RecentInfoState createState() => _RecentInfoState();
}

class _RecentInfoState extends State<RecentInfo> {
  Future<Imdb> _imdb;
  bool isClicked = false;
  String plot = "Loading...";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map search = ModalRoute.of(context).settings.arguments;
    final double height = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    final double width = MediaQuery.of(context).size.width;
    final borderRadius = BorderRadius.circular(5);
    if (_imdb == null) {
      _imdb = getImdb(search["imdbcode"]);
    }
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: 5.0),
          width: width,
          height: height,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    width: width * 0.30,
                    height: height * 0.25,
                    child: Card(
                      shape:
                          RoundedRectangleBorder(borderRadius: borderRadius),
                      child: ClipRRect(
                        borderRadius: borderRadius,
                        child: CachedNetworkImage(
                          fit: BoxFit.fill,
                          imageUrl: search["imgurl"],
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
                  buildInfo(search["imdbcode"],width,height)
                ],
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: FutureBuilder(
                  future: _imdb,
                  builder: (BuildContext ctx, AsyncSnapshot<Imdb> snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data.plot,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        "Error !",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      );
                    }
                    return Text(
                      "Loading...",
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    );
                  },
                ),
              ),
//                SizedBox(height: 20.0,),
              Flexible(
//                height: height,
                child: FutureBuilder<List<TorrentInfo>>(
                    future: getInfos( search["imdbcode"]),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return AnimationLimiter(
                          child: ListView.builder(
                            itemCount:snapshot.data.length,
                            itemBuilder: (BuildContext ctxt, int index){
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: Duration(milliseconds: 300),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: TorrentCard(snapshot.data[index]),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        switch(snapshot.error.runtimeType){
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
                      }
                      else
                      {
                        return Center(
                            child: SpinKitThreeBounce(
                              color: Theme.of(context).brightness == Brightness.dark ? Colors.grey : Theme.of(context).accentColor ,
                            )
                        );
                      }
                    }
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInfo(String imdbid,double width,double height) {
    return Container(
      height: height*0.25,
      width: width * 0.60,
      child: FutureBuilder(
        future: _imdb,
        builder: (BuildContext ctx, AsyncSnapshot<Imdb> snapshot) {
          if (snapshot.hasData) {
            plot = snapshot.data.plot;
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                      text: "Title : ",
                      style: TextStyle(
                        fontSize: 16,
                          fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: snapshot.data.title,
                            style: TextStyle(fontWeight: FontWeight.normal))
                      ]),
                ),
                RichText(
                  text: TextSpan(
                      text: "Rating : ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: snapshot.data.imdbRating,
                            style: TextStyle(fontWeight: FontWeight.normal))
                      ]),
                ),
                RichText(
                  text: TextSpan(
                      text: "Year : ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: snapshot.data.year,
                            style: TextStyle(fontWeight: FontWeight.normal))
                      ]),
                )
              ],
            );
          } else if (snapshot.hasError) {
            switch (snapshot.error.runtimeType) {
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
        },
      ),
    );
  }


  Future<Imdb> getImdb(String id) async {
    var response;
    response =
        await http.get('https://torr-scraper.herokuapp.com/api/imdb?id=$id');
    if (response.statusCode == 200) {
      return Imdb.fromJson(json.decode(response.body));
    } else if (response.statusCode == 204) {
      throw NoContentFoundException();
    } else if (response.statusCode == 500) {
      throw InternalServerError();
    }
  }
  Future<List<TorrentInfo>> getInfos(String query) async{
    var response;
    response = await http.get('https://torr-scraper.herokuapp.com/api/tgx?search=$query');
    if (response.statusCode == 200) {
      return TorrentRepo.fromJSON(json.decode(response.body)).torrentInfo;
    } else if(response.statusCode == 204){
      throw NoContentFoundException();
    }else if(response.statusCode == 500) {
      throw InternalServerError();
    }
  }
}
