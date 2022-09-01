
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/files.dart';
import 'package:video/properties/properties.dart';

import '../showdialogbox/rename_folder_file.dart';
import 'package:share_plus/share_plus.dart';


class Bottom_model extends StatefulWidget {

  final List<video> file_detail;
  final int v_id;
  final int f_id;
  void Function(BuildContext context, int id, int f_id) onPressed;
   Bottom_model({Key? key, required this.file_detail, required this.v_id, required this.f_id, required this.onPressed})
      : super(key: key);

  @override
  State<Bottom_model> createState() => _Bottom_modelState();
}

class _Bottom_modelState extends State<Bottom_model> {
  @override
  // ignore: non_constant_identifier_names



Widget text(String text){
  return Text(text ,  style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
           ),);
}

Widget icons(IconData icon){
  return Icon(icon,color:Theme.of(context).secondaryHeaderColor,);
}
  Widget build(BuildContext context) {

  int f_index=Provider.of<folder_details>(context, listen: false).folder_index(widget.f_id);

  int v_index=Provider.of<folder_details>(context, listen: false).folder_video_index(f_index,widget.v_id);
   var videos=Provider.of<folder_details>(context, listen: false).getvideo(f_index,v_index);
   
    return Wrap(
      children: <Widget>[
         ListTile(
          leading: icons(Icons.play_arrow_outlined),
          title: text("Play Next",),
          onTap: (){
            List<video>f_videos=[videos];
              Provider.of<queue_playerss>(context,
                                  listen: false)
                              .play_next_queue(f_videos);
               Navigator.of(context).pop();
          },
          
          
        ),
         ListTile(
          leading: icons(Icons.lock),
          title: text("Lock Folder"),
        ),
         ListTile(leading: icons(Icons.playlist_add), title:  text("Add to PlayList"),onTap: () {
            Navigator.pop(context);
            widget.onPressed(context,v_index,f_index);
          } ,),
       ListTile(leading: icons(Icons.delete), title: text("Delete"),onTap: (){
           Navigator.pop(context);    
         Provider.of<folder_details>(context, listen: false).delete_one_file(videos);

       } ),
       ListTile(leading: icons(Icons.share), title: text("Share"),onTap: () async {
            
            await Share.shareFiles([videos.v_videoPath]);
            Navigator.of(context).pop();
       }),
       ListTile(leading: icons(Icons.edit), title: text("Rename"),
      
        onTap: (){
              Navigator.pop(context);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                ///rename file in list
                return Rename_file_folder(condition: false,f_id:widget.f_id ,v_id:widget.v_id);
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
                return video_property(
                    f_index: f_index,v_index: v_index,);
              },
            );
          },
        ),
      ],
    );
  }
}
