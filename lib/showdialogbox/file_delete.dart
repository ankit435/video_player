import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/Playlist/video_song_screen/video_and_song_screent.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/storage.dart';

import '../Videos/video.dart';
import '../helper/files.dart';

class Delete_file_dialog extends StatefulWidget {
 
 Future<void> Function() ondelete;
   Delete_file_dialog(
      {Key? key,required this.ondelete ,}
      )
      : super(key: key);
  @override
  State<Delete_file_dialog> createState() => _Delete_file_dialogState();
}

class _Delete_file_dialogState extends State<Delete_file_dialog> {
  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: AlertDialog(
          insetPadding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          scrollable: true,
          title: Text('Delete Video from Device'),
          content: Container(
           child: Text("Video will be delete permanetly"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: (){Navigator.pop(context);widget.ondelete();},
              child: const Text('Delete'),
            ),
          ],
        ));
  }
}
