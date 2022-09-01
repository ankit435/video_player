

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/files.dart';
import 'package:video/helper/storage.dart';

class video_property extends StatefulWidget {


final int v_index;
final int f_index;
  const video_property({Key? key, required this.v_index , required this.f_index}) : super(key: key);
  @override
  State<video_property> createState() => _video_propertyState();
}

class _video_propertyState extends State<video_property> {
  @override
  var video;

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());
    return [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
  }
  Widget text(String text){
  return Text(text , style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
           ));
}
  Widget build(BuildContext context) {

  video=Provider.of<folder_details>(context, listen: true).getvideo(widget.f_index,widget.v_index);

    return Scaffold(
        backgroundColor: Colors.transparent,
        body:
         AlertDialog(
            insetPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          scrollable: true,
          title: text('Properties'),
          content: Container(
            width: MediaQuery.of(context).size.width-20,
            child: Column(
                children:  <Widget>[
                  ListTile(leading: text("File    "), title: text(video.v_title),),
                  ListTile(leading: text("Location"), title: text(video.v_videoPath),),
                  ListTile(leading: text("Size    "), title: text(Storage().getFileSize(video.v_size,1)),),
                  ListTile(leading: text("Date    "), title: text(video.v_lastmodified.toString()),),
                  ListTile(leading: text("Format  "), title: text(Storage().getFileExtension(video.v_title)),),   
                  ListTile(leading: text("Length  "), title: text(video.v_duration==-1?"not_initialize":getDuration(video.v_duration.toDouble())),),         
                ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: text('OK'),
            ),
          ],
        ));
  }
}
