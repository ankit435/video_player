import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/Playlist/video_song_screen/video_and_song_screent.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/storage.dart';
import 'package:video/showdialogbox/show_subtitile.dart';

import '../Videos/video.dart';
import '../helper/files.dart';

class Subtitle_screen extends StatefulWidget {
  Subtitle_screen({Key? key}) : super(key: key);
  @override
  State<Subtitle_screen> createState() => _Subtitle_screenState();
}

class _Subtitle_screenState extends State<Subtitle_screen> {
  @override
 Widget text(String text,{TextStyle? style,double size=16,maxLines,Color? color,FontWeight? weight , TextAlign align= TextAlign.center,}) {
    return Text(text,
    maxLines: maxLines,
    textAlign:align,
    style: style?? TextStyle(
      color:color?? Theme.of(context).textTheme.bodyText1!.color,
      fontSize: size,
      fontWeight: weight,
    //  fontFamily: 'Roboto',
    ),);

  }

  Widget build(BuildContext context) {
   return GestureDetector (
      onTap: (){
        Navigator.of(context).pop();
      
      },
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor,
            insetPadding: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            scrollable: true,
            //title: text("subtitle"),
            //ListTile(title: text("Subtitle"),subtitle: text("None"),),
            content: Column(
              children: [
                ListTile(
                  title: text("Subtitle"),
                  subtitle: text("None"),
                ),
                Divider(),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Show_subtitle();
                        });
                  },
                  title: text("Select"),
                ),
                ListTile(
                  onTap: () {},
                  title: text("Open form"),
                ),
                ListTile(
                  onTap: () {},
                  title: text("Download"),
                ),
                ListTile(
                  onTap: () {},
                  title: text("Customese"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child:Text('Cancel'),
              ),
            ],
          )),
    );
  }
}
