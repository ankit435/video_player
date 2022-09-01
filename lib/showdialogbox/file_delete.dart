import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/Playlist/video_song_screen/video_and_song_screent.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/storage.dart';

import '../Videos/video.dart';
import '../helper/files.dart';

class Show_dialog extends StatefulWidget {
 
 Future<void> Function() onPressed;
 final String title;
 final String text;
 final String onPressedtext;
        Show_dialog(
      {Key? key,required this.onPressed,required this. text ,required this.title,required this.onPressedtext}
      )
      : super(key: key);
  @override
  State<Show_dialog> createState() => _Show_dialogState();
}

class _Show_dialogState extends State<Show_dialog> {
  @override

  Widget text(String text){
  return Text(text , style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
           ));
}
  
  Widget build(BuildContext context) {
    return Scaffold(
      
        backgroundColor: Colors.transparent,
        body: AlertDialog(
          insetPadding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          scrollable: true,
          title: text(widget.title),
          content: Container(
           child: text(widget.text),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:  text('Cancel'),
            ),
            TextButton(
              onPressed: (){Navigator.pop(context);widget.onPressed();},
              child: text(widget.onPressedtext),
            ),
          ],
        ));
  }
}
