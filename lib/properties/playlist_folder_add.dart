


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/files.dart';

import '../showdialogbox/Rename_playlist_file_and_folder.dart';
import '../showdialogbox/file_delete.dart';

class PlayListfolder_add extends StatefulWidget {
  final String p_id;
  void Function(BuildContext context, int p_id) onPressed;
  void Function(Set<String> p_id) on_delete;

  PlayListfolder_add({Key? key,required this.p_id, required this.onPressed,  required this.on_delete }) : super(key: key);

  @override
  State<PlayListfolder_add> createState() => _PlayListfolder_addState();
}

class _PlayListfolder_addState extends State<PlayListfolder_add> {
  @override

  Widget text(String text){
  return Text(text , style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
           ));
}
Widget icons(IconData icon){
  return Icon(icon,color:Theme.of(context).secondaryHeaderColor,);
}

// Future<void> ondelete({int? p_id,int? v_id,int? f_id}) async {
//     Provider.of<PlayList_detail>(context, listen: false).remove_playlist_folder(widget. p_id);
// }



  Widget build(BuildContext context) {
    var p_index=Provider.of<PlayList_detail>(context, listen: false).getplayList_index_id(widget.p_id);
    return Wrap(
      children: <Widget>[
         ListTile(
          leading: icons(Icons.headphones),
          title:  text("Background_play"),
          onTap: (){
            Provider.of<queue_playerss>(context,
                                  listen: false)
                              .add_video_list_in_queue(0,Provider.of<PlayList_detail>(context, listen: false).getPlayListWithplay_id(widget.p_id));
                     Navigator.of(context).pop();
          },
        ),
         ListTile(
          leading: icons(Icons.play_arrow_outlined),
          title: text("Play Next"),
            onTap: (){
              Provider.of<queue_playerss>(context,
                                  listen: false)
                              .play_next_queue(Provider.of<PlayList_detail>(context, listen: false).getPlayListWithplay_id(widget.p_id));
               Navigator.of(context).pop();
          },
        ),

        ListTile(
          leading:  icons(Icons.playlist_add),
          title:text("Add to PlayList"),
          onTap: () {
            Navigator.pop(context);
            widget.onPressed(context,p_index);
          },
        ),
        ListTile(
            leading: icons(Icons.queue_play_next), title: text("Add to queue"),onTap: (){
                Provider.of<queue_playerss>(context,
                                  listen: false)
                              .add_to_queue(Provider.of<PlayList_detail>(context, listen: false).getPlayListWithplay_id(widget.p_id));
                     Navigator.of(context).pop();
            },),
        ListTile(
          leading: icons(Icons.delete),
          title: text("Delete"),
          onTap: () {
             Navigator.pop(context);
            showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Show_dialog(onPressedtext:"Delete",onPressed:(){widget.on_delete({widget.p_id});},title: "Delete Folder from PlayList",text:"Are you sure you want to Delete this PlayList?");
                    });
            
           
            
          },
        ),
       ListTile(leading: icons(Icons.edit), title: text("Rename"),

          onTap: (){
             Navigator.pop(context);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Rename_playlist_file_and_folder(v_id: "0", condition: true,p_id: widget.p_id,);
              },
            );
          }

       ),
       
      ],
    );
  }
}
