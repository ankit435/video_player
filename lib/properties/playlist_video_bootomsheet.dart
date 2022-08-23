import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:video/helper/files.dart';
import 'package:video/properties/properties.dart';

import '../helper/cruds_operation.dart';
import '../helper/file.dart';
import '../showdialogbox/Rename_playlist_file_and_folder.dart';

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
  

  Widget build(BuildContext context) {
    int f_index = Provider.of<folder_details>(context, listen: false)
        .folder_index(widget.f_id);
    int v_index = Provider.of<folder_details>(context, listen: false)
        .folder_video_index(f_index, widget.v_id);
    var videos=Provider.of<folder_details>(context, listen: false).getvideo(f_index,v_index);

  
    return Wrap(
      children: <Widget>[
         ListTile(
          leading: Icon(Icons.play_arrow_outlined),
          title: Text("Play Next"),
          onTap: (){
            List<video>videoss=[videos];
            Provider.of<queue_playerss>(context,
                                  listen: false)
                              .play_next_queue(videoss);
               Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.playlist_add),
          title: const Text("Add to PlayList"),
          onTap: () {
            Navigator.pop(context);
            widget.onPressed(context, v_index, f_index);
          },
        ),
         ListTile(
            leading: Icon(Icons.queue_play_next), title: Text("Add to queue"),onTap: (){
              List<video>videoss=[videos];
              

                Provider.of<queue_playerss>(context,
                                  listen: false)
                              .add_to_queue(videoss);
               Navigator.of(context).pop();
                  
            },),
        ListTile(
          leading: Icon(Icons.remove_circle_outline_outlined),
          title: Text("Remove"),
          onTap: () {
            Navigator.pop(context);
           // cruds_operation().delete_play_list_video(widget.p_id, video);
            // Provider.of<folder_details>(context, listen: false).delete_one_file(video);
          },
        ),
        const ListTile(leading: Icon(Icons.share), title: Text("Share")),


         ListTile(
          leading: Icon(Icons.edit),
          title: Text("Rename"),
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
          leading: Icon(Icons.details),
          title: Text("Properties"),
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
