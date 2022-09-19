

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/Playlist/video_song_screen/video_and_song_screent.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/storage.dart';
import 'package:video/properties/setting.dart';

import '../Videos/video.dart';
import '../helper/files.dart';




class Start_Resume extends StatefulWidget {
  static const routeName = '/decoder';


        Start_Resume(
      {Key? key  ,}
      )
      : super(key: key);
  @override
  State<Start_Resume> createState() => _Start_ResumeState();
}

class _Start_ResumeState extends State<Start_Resume> {
  @override

  Widget text(String text){
  return Text(text , style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
           ));
  }



  Widget build(BuildContext context) {
    return GestureDetector (
      onTap:(){ Navigator.of(context).pop();},
      child: Scaffold(
        
          backgroundColor: Colors.transparent,
          body: AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor,
            insetPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            scrollable: true,
            
            content: 
            Column(children:<Widget> [
               
            ],),
          
          actions: [
              TextButton(onPressed: (){}, child: const Text("Start")),
              TextButton(onPressed: (){}, child: const Text("Resume")),

          ],
          )
          
          ),
    );
  }
}
