import 'dart:math';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:torrentsearch/network/ApiConstants.dart';
import 'package:torrentsearch/utils/Preferences.dart';

class AccentList extends StatefulWidget {

  @override
  _AccentListState createState() => _AccentListState();
}

class _AccentListState extends State<AccentList> {
  final Preferences pref = Preferences();
  Map map = Map();

  Widget build(BuildContext context) {
     return ListView.builder(
      itemCount: ApiConstants.INDEXERS.length,
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (ctx,index){
        return FutureBuilder(
            future: pref.getIndexers(ApiConstants.INDEXERS[index]),
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                bool value = snapshot.data;
                if(map.containsKey(ApiConstants.INDEXERS[index])){
                  map.update(ApiConstants.INDEXERS[index], (existingvalue) => value, ifAbsent: ()=> value);
                }else{
                  map[ApiConstants.INDEXERS[index]] = value;
                }
                return ListTile(
                  title: Text(ApiConstants.INDEXERS[index]),
                  trailing: Switch(
                    activeColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey
                        : Theme.of(context).accentColor,
                    onChanged: (val) async {

                      map.update(ApiConstants.INDEXERS[index], (existingvalue) => value, ifAbsent: ()=> value);
                      await pref.setIndexers(ApiConstants.INDEXERS[index],val);
                      setState((){
                        value = val;
                      });
                    },
                    value: value,
                  ),
                );
              } else {
                return Container(
                  height: 0.0,
                  width: 0.0,
                );
              }
            });
      },
    );
  }


}
