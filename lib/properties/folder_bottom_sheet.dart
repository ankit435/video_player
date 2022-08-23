


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:video/helper/files.dart';

import '../helper/file.dart';
import '../showdialogbox/rename_folder_file.dart';

class Floder_bottomsheet extends StatefulWidget {
  void Function(BuildContext context, List<video>folders) bottoplaylist;

  final int f_Id;
  final int v_id;

   Floder_bottomsheet({Key? key, required this.bottoplaylist, required this.f_Id ,required this.v_id}) : super(key: key);

  @override
  State<Floder_bottomsheet> createState() => _Floder_bottomsheetState();
}

class _Floder_bottomsheetState extends State<Floder_bottomsheet> {
  @override
  Widget build(BuildContext context) {
    var f_videos=Provider.of<folder_details>(context, listen: false).getfoldertotalvideo(widget.f_Id,"Name",false);
    var f_index=Provider.of<folder_details>(context, listen: false).folder_index(widget.f_Id);
  // f_videos.forEach((element) => print(element.v_id));
    return Wrap(
      children: <Widget>[
         ListTile(
          leading: Icon(Icons.play_arrow_outlined),
          title: Text("Play Next"),
          onTap: (){
              Provider.of<queue_playerss>(context,
                                  listen: false)
                              .play_next_queue(f_videos);
               Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: const Icon(Icons.playlist_add),
          title: const Text("Add to PlayList"),
          onTap: () {
            Navigator.pop(context);
            widget.bottoplaylist(context,f_videos);
          },
        ),
         ListTile(
            leading: Icon(Icons.queue_play_next), title: Text("Add to queue"),onTap: (){
               Provider.of<queue_playerss>(context,
                                  listen: false)
                              .add_to_queue(f_videos);
                     Navigator.of(context).pop();
            },),
        ListTile(
          leading: Icon(Icons.delete),
          title: Text("Delete"),
          onTap: () {
            Navigator.pop(context);
            Provider.of<folder_details>(context, listen: false).deleteFolder(widget.f_Id);
          },
        ),
        ListTile(leading: Icon(Icons.edit), title: Text("Rename"),
        onTap: (){

            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                //rename folder
                return Rename_file_folder(condition: true,f_id:widget.f_Id ,v_id:widget.f_Id);
              },
            );

        },),
       
      ],
    );
  }
}
