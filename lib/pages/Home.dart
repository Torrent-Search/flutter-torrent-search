import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/utils/DarkThemeProvider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _textEditingController;
  String searchText = "";
//  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkThemeProvider>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final Color accentColor = Theme.of(context).accentColor;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Center(
            child: Container(
              width: width,
              height: (height * 60) / 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
//            SizedBox(height: 120,),
                  Text(
                    "Torrent Search",
                    style: TextStyle(
                      fontSize: 30.0,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      color: accentColor,
                    ),
                  ),
//            SizedBox(height: 70.0,),
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(
                                color: accentColor, width: 2.0),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                      cursorColor: accentColor,
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Dark Mode",
                        style: TextStyle(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black),
                      ),
                      Switch(
                        value: themeProvider.darkTheme,
                        activeColor: Theme.of(context).accentColor,
                        onChanged: (bool val) {
                          setState(() {
                            themeProvider.darkTheme = val;
                          });
                        },
                      )
                    ],
                  ),
                  RaisedButton.icon(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    label: Text(
                      "SEARCH",
                      style: TextStyle(
                        letterSpacing: 2.0,
                        color: Colors.white,
                      ),
                    ),
                    color: Theme.of(context).accentColor,
                    onPressed: () {
                      if (_textEditingController.text != "") {
                        Navigator.pushNamed(context, "/result",
                            arguments: _textEditingController.text);
                      }
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
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
//                        builder: (BuildContext ctx){
//                          return _buildAccentDialog(ctx);
//                        },
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Text(
              EmojiParser().emojify("Made with :heart: in India"),
              style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                  fontFamily: "OpenSans"),
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
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
}
