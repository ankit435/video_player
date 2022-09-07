import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:video/helper/files.dart';
import 'package:video/properties/properties.dart';

import '../helper/cruds_operation.dart';
import '../helper/file.dart';
import '../showdialogbox/Rename_playlist_file_and_folder.dart';
import 'package:share_plus/share_plus.dart';

import '../showdialogbox/file_delete.dart';

class playlistbootoomshet extends StatefulWidget {
  final String p_title;
  final String v_id;
  final String f_id;
  final String p_id;
  void Function(BuildContext context, String v_id, String f_id) onPressed;
  void Function(Map<String, String> delete) on_delete;
  playlistbootoomshet(
      {Key? key,
      required this.p_id,
      required this.p_title,
      required this.v_id,
      required this.f_id,
      required this.onPressed, required this.on_delete})
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
 
    var videos=Provider.of<folder_details>(context, listen: false).gevideo(widget.f_id,widget.v_id);

  
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
            widget.onPressed(context, widget.v_id, widget.f_id);
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
            Map<String,String> delete={widget.p_id:widget.v_id};
          
            showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Show_dialog(onPressedtext:"Remove",onPressed:(){widget.on_delete(delete);},title: "Playlist",text:"Are you sure you want remove this Video?");
                    });
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
                return video_property(v_id: widget.v_id, f_id: widget.f_id);
              },
            );
          },
        ),
      ],
    );
  }
}
