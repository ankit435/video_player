
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/files.dart';
import 'package:video/properties/properties.dart';

import '../showdialogbox/file_delete.dart';
import '../showdialogbox/rename_folder_file.dart';
import 'package:share_plus/share_plus.dart';


class Bottom_model extends StatefulWidget {

  final List<video> file_detail;
  final String v_id;
  final String f_id;
  //Future<void> Function(Map<int, int> delete) ondelete;
  void Function(BuildContext context, String v_id, String f_id) onPressed;
  Future<void> Function(Map<String, String> single_video_list) onsinglefiledelete;
  bool recent_played=false;
   Bottom_model({Key? key, required this.file_detail, required this.v_id, required this.f_id, required this.onPressed, required this. onsinglefiledelete,this.recent_played=false 
   ///required this.ondelete
  })
      : super(key: key);

  @override
  State<Bottom_model> createState() => _Bottom_modelState();
}

class _Bottom_modelState extends State<Bottom_model> {
  @override
  // ignore: non_constant_identifier_names

Map<String,String>delete={};
Widget text(String text){
  return Text(text , maxLines: 1,overflow: TextOverflow.ellipsis,  style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
           ),);
}



Widget icons(IconData icon){
  return Icon(icon,color:Theme.of(context).iconTheme.color,);
}


  Widget build(BuildContext context) {

   var videos=Provider.of<folder_details>(context, listen: false).gevideo(widget.f_id,widget.v_id);
   
    return Wrap(
      children: <Widget>[

        Container(child: Padding(
          padding: const EdgeInsets.only(left: 20, top: 20,bottom: 10),
          child: text(videos.v_title),
        )),
        Divider(),

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
          onTap: (){ Provider.of<recent_videos>(context, listen: false).add_to_recent(videos) ;},
        ),
         ListTile(leading: icons(Icons.playlist_add), title:  text("Add to PlayList"),onTap: () {
            Navigator.pop(context);
            widget.onPressed(context,widget.v_id,widget.f_id);
          } ,),
       ListTile(leading: icons(Icons.delete), title: text("Delete"),onTap: (){
          
              Navigator.pop(context);    
             
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Show_dialog(onPressedtext:"Delete",onPressed:(){widget.onsinglefiledelete({widget.v_id:widget.f_id});},title: "Delete Video from Device",text:"Are you sure you want to delete this File?");
                    });
       

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
                return Rename_file_folder(condition: false,f_id:widget.f_id ,v_id:widget.v_id,rename_name: videos.v_title,);
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
