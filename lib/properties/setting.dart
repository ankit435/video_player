// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:video/helper/files.dart';

class Setting extends StatefulWidget {
  Future<void> Function() loaddata;
   Setting({Key? key, required this.loaddata }) : super(key: key);
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

  Widget listiles(String titles, {String subtitle="", String key="",Function? param1} ) {
    return ListTile(
        title: text(titles),
        subtitle: subtitle.isNotEmpty ? text(subtitle) : null,
        trailing: key.isNotEmpty ? Switch_button(true) : null,
        onTap: param1==null?null:() {
          param1();
        });

        
        
  }

  Widget text(String text){
  return Text(text , style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
           ));
}

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar( 
          backgroundColor: Theme.of(context).primaryColor,
       title: text("Setting")),
        body:Container(
             color: Theme.of(context).backgroundColor,
          child: Center(
            child: SingleChildScrollView (
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 0, 3),
                    alignment: Alignment.centerLeft,
                    child: Text("General",style: TextStyle(color: Colors.red),),
                    
                  ),
                  Column(
                    children: [
                      listiles("Theme", subtitle: Theme.of(context).toString(),param1:(){
                        Navigator.pushNamed(context, '/theme_screen');
                        widget.loaddata();
                      }),
                      listiles("Language",subtitle:  "Auto", param1:(){
                      Provider.of<themes>(context,listen: false).update_curr_theme_id(2);
                      }),
                    ],
                  ),
                 Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 0, 3),
                    alignment: Alignment.centerLeft,
                    child: Text("Media",style: TextStyle(color: Colors.red),),
                    
                  ),
                  Column(
                    children: [
                      listiles("Show dotFolder", key: "Folder"),
                      listiles("Show dotFile", key: "File"),
                      listiles("History", key: "History"),
                    ],
                  ),
                 Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 0, 3),
                    alignment: Alignment.centerLeft,
                    child: Text("Premium",style: TextStyle(color: Colors.red),),
                    
                  ),
                  Column(
                    children: [
                      listiles("Show dotFolder", key:  "Folder"),
                      listiles("Show dotFile",key: "File"),
                      listiles("History", key:  "History"),
                    ],
                  ),
                 Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 0, 3),
                    alignment: Alignment.centerLeft,
                    child: Text("Decoder",style: TextStyle(color: Colors.red),),
                    
                  ),
                  Column(
                    children: [
                       listiles("Show dotFolder", key:  "Folder"),
                      listiles("Show dotFile", key: "File"),
                      listiles("History",key: "History"),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 5, 0, 3),
                    alignment: Alignment.centerLeft,
                    child: Text("Decoder",style: TextStyle(color: Colors.red),),
                    
                  ),
                  Column(
                    children: [
                       listiles("Show dotFolder", key:  "Folder"),
                      listiles("Show dotFile", key: "File"),
                      listiles("History",key:  "History"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
