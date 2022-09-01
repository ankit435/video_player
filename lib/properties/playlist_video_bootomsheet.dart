import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:video/helper/files.dart';
import 'package:video/properties/properties.dart';

import '../helper/cruds_operation.dart';
import '../helper/file.dart';
import '../showdialogbox/Rename_playlist_file_and_folder.dart';
import 'package:share_plus/share_plus.dart';

class playlistbootoomshet extends StatefulWidget {
  final String p_title;
  final int v_id;
  final int f_id;
  final int p_id;
  void Function(BuildContext context, int id, int f_id) onPressed;
  playlistbootoomshet(
      {Key? key,
      required this.p_id,
      required this.p_title,
      required this.v_id,
      required this.f_id,
      required this.onPressed})
      : super(key: key);

  @override
  State<playlistbootoomshet> createState() => _playlistbootoomshetState();
}

class _playlistbootoomshetState extends State<playlistbootoomshet> {
  @override
  Widget text(String text){
  return Text(text , style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
           ));
}
Widget icons(IconData icon){
  return Icon(icon,color:Theme.of(context).secondaryHeaderColor,);
}

  Widget build(BuildContext context) {
    int f_index = Provider.of<folder_details>(context, listen: false)
        .folder_index(widget.f_id);
    int v_index = Provider.of<folder_details>(context, listen: false)
        .folder_video_index(f_index, widget.v_id);
    var videos=Provider.of<folder_details>(context, listen: false).getvideo(f_index,v_index);

  
    return Wrap(
      children: <Widget>[
         ListTile(
          leading: icons(Icons.play_arrow_outlined),
          title: text("Play Next"),
          onTap: (){
            List<video>videoss=[videos];
            Provider.of<queue_playerss>(context,
                                  listen: false)
                              .play_next_queue(videoss);
               Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading:  icons(Icons.playlist_add),
          title:  text("Add to PlayList"),
          onTap: () {
            Navigator.pop(context);
            widget.onPressed(context, v_index, f_index);
          },
        ),
         ListTile(
            leading: icons(Icons.queue_play_next), title: text("Add to queue"),onTap: (){
              List<video>videoss=[videos];
              

                Provider.of<queue_playerss>(context,
                                  listen: false)
                              .add_to_queue(videoss);
               Navigator.of(context).pop();
                  
            },),
        ListTile(
          leading: icons(Icons.remove_circle_outline_outlined),
          title: text("Remove"),
          onTap: () {
            Navigator.pop(context);
           // cruds_operation().delete_play_list_video(widget.p_id, video);
            // Provider.of<folder_details>(context, listen: false).delete_one_file(video);
          },
        ),
         ListTile(leading: icons(Icons.share), title: text("Share"),onTap: () async {
          Navigator.of(context).pop();
           await Share.shareFiles([videos.v_videoPath]);
           
         },),


         ListTile(
          leading: icons(Icons.edit),
          title: text("Rename"),
          onTap: (){
             Navigator.pop(context);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                //rename playlist video
                return Rename_playlist_file_and_folder(v_id: widget.v_id, condition: false,p_id: widget.p_id,);
              },
            );
          }
        ),
        ListTile(
          leading: icons(Icons.details),
          title: text("Properties"),
          onTap: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return video_property(v_index: v_index, f_index: f_index);
              },
            );
          },
        ),
      ],
    );
  }
}
