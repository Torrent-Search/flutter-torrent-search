import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:torrentsearch/network/NetworkProvider.dart';
import 'package:torrentsearch/utils/DarkThemeProvider.dart';
import 'package:torrentsearch/widgets/IndexersList.dart';

class Settings extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Settings> {
  PackageInfo packageInfo ;
  String version;
  final List colors0 = [
    Colors.deepPurpleAccent.value,
    Colors.red.value,
    Colors.blue.value
  ];
  final List colors1 = [
    Colors.deepOrange.value,
    Colors.cyan.value,
    Colors.green.value
  ];
  Future<bool> _init()async{
    version = await getAppVersion();
    return true;
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final themeProvider = Provider.of<DarkThemeProvider>(context);
//    final updateStatusProvider = Provider.of<UpdateStatusProvider>(context);

   return SafeArea(
     child: Scaffold(
       body: Container(
         decoration: BoxDecoration(
           color:Theme.of(context).backgroundColor,
          ),
         height: height,
         width: width,
         child: ListView(
           shrinkWrap: true,
           scrollDirection: Axis.vertical,
           children: <Widget>[
             ListTile(
               title:  Text(
                 "Dark Mode",
                 style: TextStyle(letterSpacing: 2.0),
               ),
               trailing: Switch(
                 value: themeProvider.darkTheme,
                 activeColor: Theme.of(context).brightness == Brightness.dark
                     ? Colors.grey
                     : Theme.of(context).accentColor,
                 onChanged: (bool val) {
                   setState(() {
                     themeProvider.darkTheme = val;
                   });
                 },
               ),
             ),
             ExpansionTile(
               title: Text(
                 "Accent",
                 style: TextStyle(
                   letterSpacing: 2.0,
                 ),
               ),
               trailing: Icon(Icons.keyboard_arrow_down),
               children: <Widget>[
                 Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: colors0.map((e) {
                       return InkWell(
                         onTap: () {
                           setState(() {
                             themeProvider.accent = e;
                           });
                         },
                         child: CircleAvatar(
                           radius: 20.0,
                           backgroundColor: Color(e),
                         ),
                       );
                     }).toList()),
                 SizedBox(
                   height: 20,
                 ),
                 Row(
                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                     children: colors1.map((e) {
                       return InkWell(
                         onTap: () {
                           setState(() {
                             themeProvider.accent = e;
                           });
                         },
                         child: CircleAvatar(
                           radius: 20.0,
                           backgroundColor: Color(e),
                         ),
                       );
                     }).toList()),
                 SizedBox(
                   height: 40,
                 ),
               ],
             ),
             ExpansionTile(
               title: Text(
                 "Indexers",
                 style: TextStyle(letterSpacing: 2.0),
               ),
               trailing: Icon(Icons.keyboard_arrow_down),
               children: <Widget>[
                 IndexersList(),
               ],
             ),
             Center(
               child: Padding(
                 padding: EdgeInsets.symmetric(vertical: 10.0),
                 child: Text(
                   EmojiParser().emojify("Made with :heart: in India"),
                   style: TextStyle(
                     letterSpacing: 2.0,
                     fontWeight: FontWeight.bold,
                     fontSize: 15,
                   ),
                 ),
               ),
             )
           ],
         ),
       ),
     ),
   );
  }
}
