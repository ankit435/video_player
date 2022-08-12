// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);
  static const routeName = '/setting';

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  Map<String, bool> switch_button = {
    "Folder": false,
    "File": false,
    "History": false
  };
  @override
  Widget Switch_button(
    bool isSwitched,
  ) {
    return Switch(
      value: isSwitched,
      onChanged: (value) {
        setState(() {
          isSwitched = value;
        });
      },
      activeTrackColor: Colors.lightGreenAccent,
      activeColor: Colors.green,
    );
  }

  Widget listiles(String titles, String subtitle, String key) {
    return ListTile(
        title: Text(titles),
        subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
        trailing: key.isNotEmpty ? Switch_button(true) : null);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Setting")),
        body:SingleChildScrollView (
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 0, 3),
                alignment: Alignment.centerLeft,
                child: Text("General",style: TextStyle(color: Colors.red),),
                
              ),
              Column(
                children: [
                  listiles("Theme", "default theme", ""),
                  listiles("Language", "Auto", ""),
                ],
              ),
             Container(
                padding: EdgeInsets.fromLTRB(10, 5, 0, 3),
                alignment: Alignment.centerLeft,
                child: Text("Media",style: TextStyle(color: Colors.red),),
                
              ),
              Column(
                children: [
                  listiles("Show dotFolder", "", "Folder"),
                  listiles("Show dotFile", "", "File"),
                  listiles("History", "", "History"),
                ],
              ),
             Container(
                padding: EdgeInsets.fromLTRB(10, 5, 0, 3),
                alignment: Alignment.centerLeft,
                child: Text("Premium",style: TextStyle(color: Colors.red),),
                
              ),
              Column(
                children: [
                   listiles("Show dotFolder", "", "Folder"),
                  listiles("Show dotFile", "", "File"),
                  listiles("History", "", "History"),
                ],
              ),
             Container(
                padding: EdgeInsets.fromLTRB(10, 5, 0, 3),
                alignment: Alignment.centerLeft,
                child: Text("Decoder",style: TextStyle(color: Colors.red),),
                
              ),
              Column(
                children: [
                   listiles("Show dotFolder", "", "Folder"),
                  listiles("Show dotFile", "", "File"),
                  listiles("History", "", "History"),
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 0, 3),
                alignment: Alignment.centerLeft,
                child: Text("Decoder",style: TextStyle(color: Colors.red),),
                
              ),
              Column(
                children: [
                   listiles("Show dotFolder", "", "Folder"),
                  listiles("Show dotFile", "", "File"),
                  listiles("History", "", "History"),
                ],
              ),
            ],
          ),
        ));
  }
}
