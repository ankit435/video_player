import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/Playlist/video_song_screen/video_and_song_screent.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/storage.dart';
import 'package:video/properties/setting.dart';

import '../Videos/video.dart';
import '../helper/files.dart';




class Decoder extends StatefulWidget {
  static const routeName = '/decoder';

video_decoder? character;
void Function(video_decoder? val) update_decoder;
        Decoder(
      {Key? key,required this.character, required this.update_decoder  ,}
      )
      : super(key: key);
  @override
  State<Decoder> createState() => _DecoderState();
}

class _DecoderState extends State<Decoder> {
  @override

  Widget text(String text){
  return Text(text , style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
           ));
}
  int _currentIndex=0;
 
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
            
            content: Column(children:<Widget> [
               RadioListTile<video_decoder>(
              activeColor: Theme.of(context).textTheme.bodyText1!.color,
            title: text('HW_Decoder'),
            value: video_decoder.HW_Decoder,
            groupValue:widget. character,
            onChanged: (video_decoder? value) {
              setState(() {
               widget. character = value;
                widget.update_decoder(widget. character);
              });
            },
          ),
          RadioListTile<video_decoder>(
            activeColor: Theme.of(context).textTheme.bodyText1!.color,
            title:  text('SW Decoder'),
            value: video_decoder.SW_Decoder,
            groupValue:widget.character,
            onChanged: (video_decoder? value) {
              setState(() {
                widget.character = value;
                widget.update_decoder(widget.character);
              });
            },
          ),
            ],),
          
          
          )
          ),
    );
  }
}
