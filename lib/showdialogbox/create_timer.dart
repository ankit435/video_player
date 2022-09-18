import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/Playlist/video_song_screen/video_and_song_screent.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/storage.dart';

import '../Videos/video.dart';
import '../helper/files.dart';

class Create_timer extends StatefulWidget {
void Function(int value) set_sleep_timer;
int video_duration;
        Create_timer(
      {Key? key, required this.set_sleep_timer, required  this.video_duration }
      )
      : super(key: key);
  @override
  State<Create_timer> createState() => _Create_timerState();
}

class _Create_timerState extends State<Create_timer> {
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
          backgroundColor: Theme.of(context).backgroundColor,
          content: Container(


           child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              text("Set sleep timer for"),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(onPressed: (){widget.set_sleep_timer(15);Navigator.pop(context);}, child: text("15 min")),
                  TextButton(onPressed: (){widget.set_sleep_timer(30);Navigator.pop(context);}, child: text("30 min")),
                  TextButton(onPressed: (){widget.set_sleep_timer(45);Navigator.pop(context);}, child: text("45 min")),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(onPressed: (){widget.set_sleep_timer(60);Navigator.pop(context);}, child: text("1 hour")),
                  TextButton(onPressed: (){widget.set_sleep_timer(90);Navigator.pop(context);}, child: text("1.5 hour")),
                  TextButton(onPressed: (){widget.set_sleep_timer(120);Navigator.pop(context);}, child: text("2 hour")),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(onPressed: (){widget.set_sleep_timer(150);Navigator.pop(context);}, child: text("2.5 hour")),
                  TextButton(onPressed: (){widget.set_sleep_timer(180);Navigator.pop(context);}, child: text("3 hour")),
                  TextButton(onPressed: (){widget.set_sleep_timer(210);Navigator.pop(context);}, child: text("3.5 hour")),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(onPressed: (){widget.set_sleep_timer(240);Navigator.pop(context);}, child: text("4 hour")),
                  TextButton(onPressed: (){widget.set_sleep_timer(270);Navigator.pop(context);}, child: text("4.5 hour")),
                  TextButton(onPressed: (){widget.set_sleep_timer(300);Navigator.pop(context);}, child: text("5 hour")),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(onPressed: (){widget.set_sleep_timer(330);Navigator.pop(context);}, child: text("5.5 hour")),
                  TextButton(onPressed: (){widget.set_sleep_timer(360);Navigator.pop(context);}, child: text("6 hour")),
                  TextButton(onPressed: (){widget.set_sleep_timer(390);Navigator.pop(context);},
                    child: text("6.5 hour")),
                ],
           
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(onPressed: (){widget.set_sleep_timer(widget.video_duration);Navigator.pop(context);}, child: text("Video length")),
                  TextButton(onPressed: (){Navigator.pop(context);}, child: text("Cancel")),
                  
                ],
              ),
            ],
          ),
          )));
  }
}
