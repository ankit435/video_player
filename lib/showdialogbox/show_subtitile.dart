import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/Playlist/video_song_screen/video_and_song_screent.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/storage.dart';

import '../Videos/video.dart';
import '../helper/files.dart';

class Show_subtitle extends StatefulWidget {

        Show_subtitle(
      {Key? key,}
      )
      : super(key: key);
  @override
  State<Show_subtitle> createState() => _Show_subtitleState();
}

class _Show_subtitleState extends State<Show_subtitle> {
  @override

  Widget text(String text){
  return Text(text , style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
           ));
}
  int _currentIndex=0;
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
            title: ListTile(title: text("Subtitle"),subtitle: text("None"),),
            
            content: Container(
             
              width: double.minPositive,
                    height: 300,
             child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 6,
                      itemBuilder: (BuildContext context, int index) {
                        return RadioListTile(
                          activeColor: Theme.of(context).textTheme.bodyText1!.color,
                          value: index,
                          groupValue:_currentIndex,
                          title: text(" English"),
                          onChanged: ( value) {
                            setState(() {
                              _currentIndex = value as int;
                            });
                          },
                        );
                      },
                    ),
            ),
    
            actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('CANCEL'),
                    ),
                    
                  ],
           
          )),
    );
  }
}
