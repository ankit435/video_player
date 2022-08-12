


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/files.dart';

import '../showdialogbox/Rename_playlist_file_and_folder.dart';

class PlayListfolder_add extends StatefulWidget {
  final int p_id;
  void Function(BuildContext context, int p_id) onPressed;

  PlayListfolder_add({Key? key,required this.p_id, required this.onPressed }) : super(key: key);

  @override
  State<PlayListfolder_add> createState() => _PlayListfolder_addState();
}

class _PlayListfolder_addState extends State<PlayListfolder_add> {
  @override
  Widget build(BuildContext context) {
    
    return Wrap(
      children: <Widget>[
        const ListTile(
          leading: Icon(Icons.play_arrow_outlined),
          title: Text("Play Next"),
        ),
        ListTile(
          leading: const Icon(Icons.playlist_add),
          title: const Text("Add to PlayList"),
          onTap: () {
            Navigator.pop(context);
            widget.onPressed(context,widget.p_id);
          },
        ),
        const ListTile(
            leading: Icon(Icons.queue_play_next), title: Text("Add to queue")),
        ListTile(
          leading: Icon(Icons.delete),
          title: Text("Delete"),
          onTap: () {
            Navigator.pop(context);
            Provider.of<PlayList_detail>(context, listen: false).remove_playlist_folder(widget.p_id);
          },
        ),
       ListTile(leading: Icon(Icons.edit), title: Text("Rename"),

          onTap: (){
             Navigator.pop(context);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Rename_playlist_file_and_folder(v_id: 0, condition: true,p_id: widget.p_id,);
              },
            );
          }

       ),
       
      ],
    );
  }
}
