
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/files.dart';
import 'package:video/properties/properties.dart';

import '../helper/cruds_operation.dart';
import '../showdialogbox/rename_folder_file.dart';


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


  Widget build(BuildContext context) {

  int f_index=Provider.of<folder_details>(context, listen: false).folder_index(widget.f_id);

  int v_index=Provider.of<folder_details>(context, listen: false).folder_video_index(f_index,widget.v_id);
   var videos=Provider.of<folder_details>(context, listen: false).getvideo(f_index,v_index);
   
    return Wrap(
      children: <Widget>[
         ListTile(
          leading: Icon(Icons.play_arrow_outlined),
          title: Text("Play Next"),
          onTap: (){
            List<video>f_videos=[videos];
              Provider.of<queue_playerss>(context,
                                  listen: false)
                              .play_next_queue(f_videos);
               Navigator.of(context).pop();
          },
          
          
        ),
        const ListTile(
          leading: Icon(Icons.lock),
          title: Text("Lock Folder"),
        ),
         ListTile(leading: const Icon(Icons.playlist_add), title: const Text("Add to PlayList"),onTap: () {
            Navigator.pop(context);
            widget.onPressed(context,v_index,f_index);
          } ,),
       ListTile(leading: Icon(Icons.delete), title: Text("Delete"),onTap: (){
           Navigator.pop(context);    
         Provider.of<folder_details>(context, listen: false).delete_one_file(videos);

       } ),
       ListTile(leading: Icon(Icons.share), title: Text("Share"),onTap: (){}),
       ListTile(leading: Icon(Icons.edit), title: Text("Rename"),
      
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
          leading: Icon(Icons.details),
          title: Text("Properties"),
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
