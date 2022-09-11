


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video/helper/files.dart';

import '../helper/file.dart';
import '../showdialogbox/file_delete.dart';
import '../showdialogbox/rename_folder_file.dart';

class Floder_bottomsheet extends StatefulWidget {
  void Function(BuildContext context, List<video>folders) bottoplaylist;

  final String f_Id;
  final String v_id;
  Future<void> Function(Set<String> delete) onsinglefolderdelete;

   Floder_bottomsheet({Key? key, required this.bottoplaylist, required this.f_Id ,required this.v_id, required this.onsinglefolderdelete }) : super(key: key);

  @override
  State<Floder_bottomsheet> createState() => _Floder_bottomsheetState();
}

class _Floder_bottomsheetState extends State<Floder_bottomsheet> {
  @override


  Widget text(String text){
  return Text(text , style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
           ));
}



Future<void> ondelete() async {
   Provider.of<folder_details>(context, listen: false)
          .deleteFolder({widget.f_Id});
}
Widget icons(IconData icon){
  return Icon(icon,color:Theme.of(context).iconTheme.color,);
}
  Widget build(BuildContext context) {
    var f_videos=Provider.of<folder_details>(context, listen: false).getfoldertotalvideo(widget.f_Id,"Name",false);
    var f_index=Provider.of<folder_details>(context, listen: false).folder_index(widget.f_Id);
    
  // f_videos.forEach((element) => print(element.v_id));
    return Wrap(
      children: <Widget>[
         ListTile(
          leading: icons(Icons.play_arrow_outlined),
          title: text("Play Next"),
          onTap: (){
              Provider.of<queue_playerss>(context,
                                  listen: false)
                              .play_next_queue(f_videos);
               Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading:  icons(Icons.playlist_add),
          title:  text("Add to PlayList"),
          onTap: () {
            Navigator.pop(context);
            widget.bottoplaylist(context,f_videos);
          },
        ),
        ListTile(
          leading: icons(Icons.share),
          title:  text("Share"),
          onTap: () async {
            Navigator.pop(context);
            await Share.shareFiles(Provider.of<folder_details>(context, listen: false).get_folder_path({widget.f_Id}));
          },
        ),
         ListTile(
            leading: icons(Icons.queue_play_next), title: text("Add to queue"),onTap: (){
               Provider.of<queue_playerss>(context,
                                  listen: false)
                              .add_to_queue(f_videos);
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
                      return Show_dialog(onPressedtext:"Delete",onPressed:(){widget. onsinglefolderdelete({widget.f_Id});},title: "Delete Folder from Device",text:"Are you sure you want to delete this Folder?");
                    });

          },
        ),
        ListTile(leading: icons(Icons.edit), title: text("Rename"),
        onTap: (){

            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                //rename folder
                return Rename_file_folder(condition: true,f_id:widget.f_Id ,v_id:widget.f_Id,rename_name: Provider.of<folder_details>(context, listen: false).getfoldername(widget.f_Id),);
              },
            );

        },),
       
      ],
    );
  }
}
