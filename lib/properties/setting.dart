// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video/helper/files.dart';
import 'package:video/showdialogbox/Decoder.dart';
import 'package:video/theme/theme_screen.dart';

import '../showdialogbox/skip_time.dart';

enum video_decoder { HW_Decoder, SW_Decoder }
class Setting extends StatefulWidget {
//  final bool isLoading;
   Setting( {Key? key,}) : super(key: key);
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
   video_decoder? character = video_decoder.HW_Decoder;

  void update_function( String key, bool value)   {

    switch (key) {
      case "Music":
         Provider.of<Setting_data>(context,listen: false).set_show_music(value);
        break;
      case "Folder":
       
        break;
      case "Auto_play_next":
        Provider.of<Setting_data>(context,listen: false).set_Auto_play(value);
        
        break;
      case "History":
       Provider.of<Setting_data>(context,listen: false).set_show_History(value);
       
        break;
      case "Brightness":
        Provider.of<Setting_data>(context,listen: false).set_remember_brightness(value);
        break;
      
       case "Apectratio":
        Provider.of<Setting_data>(context,listen: false).set_remember_aspect_ratio(value);
        break;
      case "Resume":
        Provider.of<Setting_data>(context,listen: false).set_resume(value);
        break;
       case "Double_tap":
        Provider.of<Setting_data>(context,listen: false).set_double_tap_fast_forward(value);
        break;
      case "Back_ground_play":
        Provider.of<Setting_data>(context,listen: false).set_background_play(value);
        break;


    }
   
  }


  Widget Switch_button( String key,
    bool isSwitched,
  ) {
    return Switch(
      key:  Key(key),
      value: isSwitched,
      onChanged: (value) {
        setState(() {
          isSwitched = value;
          update_function(key, value);
           
        });
      },
      activeTrackColor: Colors.lightGreenAccent,
      activeColor: Colors.green,
    );
  }

  Future<bool> get_switch_value(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? value = prefs.getBool(key);
    if (value == null) {
      value = false;
    }
    return value;
  }

  Widget listiles(String titles, {String? subtitle, String? key,Function? param1,bool? cond,String? trailing_text} ) {
    return ListTile(
        title: text(titles),
        subtitle: subtitle==null ?null: text(subtitle),
        trailing: key!=null ? Switch_button(key, cond ?? false) : text(trailing_text),
        onTap: param1==null?null:() {
          param1();
        });
        
  }
  

  Widget? text(String? text){
  return text==null?null: Text(text , style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
           ));
  }

void update_decoder(video_decoder? val){

setState(() {
  character = val;
});
  

}
Widget body(){
  return SingleChildScrollView (
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
  
            }),
          Divider(),
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
            listiles("Show Music", key: "Music",subtitle: "Support Music player" ,cond: Provider.of<Setting_data>(context,listen: true).get_setting_show_music()),
            Divider(),
            listiles("Manage Scanlist", subtitle: "Manage Scanlist",param1:(){
              Navigator.pushNamed(context, '/Manage_scan_list');
            }),
            Divider(),
            listiles("Show History", key: "History",cond: Provider.of<Setting_data>(context,listen: true).get_setting_show_History()),
            Divider(),
            listiles("Show Hidden File", key: "Hidden file",),
          ],
        ),
       Container(
          padding: EdgeInsets.fromLTRB(10, 5, 0, 3),
          alignment: Alignment.centerLeft,
          child: Text("PlayBack",style: TextStyle(color: Colors.red),),
          
        ),
        Column(
          children: [
            listiles("Decoder", subtitle:character.toString().toString().split('.').last,param1:(){
  
                   showDialog(
          context: context,
          builder: (BuildContext context) {
            return Decoder(
               character: character,
               update_decoder:update_decoder
  
  
            );
          });
  
            }), 
            Divider(),
            listiles("Subtitle Rendring" ,),
            Divider(),
            listiles("Remember Brightness", key: "Brightness", cond: Provider.of<Setting_data>(context,listen: true).get_setting_remember_brightness()),
            Divider(),
            listiles("Remember Apect Ratio", key: "Apectratio", subtitle: "Remeber aspect Ratio of all Video",cond: Provider.of<Setting_data>(context,listen: true).get_setting_remember_aspect_ratio()),
            Divider(),
            listiles("Resume", key: "Resume", subtitle: "Continue playing from where you stopeed", cond: Provider.of<Setting_data>(context,listen: true).get_setting_resume()),
           Divider(),
            listiles("Auto Play Next", key: "Auto_play_next", cond: Provider.of<Setting_data>(context,listen: true).get_setting_Auto_play()),
           Divider(),
            listiles("Background play", key: "Back_ground_play", cond: Provider.of<Setting_data>(context,listen: true).get_setting_background_play()),
           Divider(),
            listiles("Time To Fast Forward", subtitle: "Double tap to fast forward",param1:Provider.of<Setting_data>(context,listen: true).get_setting_double_tap_fast_forward()? (){
              showDialog(
          context: context,
          builder: (BuildContext context) {
            return Skip_time();
          });
            }:null, trailing_text: Provider.of<Setting_data>(context,listen: true).get_skip_time().toString() ),
           Divider(),
            listiles("Double tap to fast forward", key: "Double_tap", cond: Provider.of<Setting_data>(context,listen: true).get_setting_double_tap_fast_forward()),
  
          ],
        ),
      ]
      
    ),
  );
  
}


  Widget build(BuildContext context) {
    return Scaffold(
     //   appBar: 
        body:Container(
          color: Theme.of(context).backgroundColor,
          child:
          
          Column(children: [
          AppBar( 
          elevation: 0,
          backgroundColor: Theme.of(context).backgroundColor,
          title: text("Setting")),
          Flexible (child: body())
          ],)
          
         )
         
         );
  }
}
