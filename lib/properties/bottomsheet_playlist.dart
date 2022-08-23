
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/Playlist/create_playList.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/files.dart';


class BottomPlayList extends StatefulWidget {


  final int v_index;
  final int f_index;
  final bool condition;
  final List<video> passvideo;
  const BottomPlayList({Key? key, required this.v_index, required this.f_index,required this.condition,required this.passvideo})
      : super(key: key);

  @override
  State<BottomPlayList> createState() => _BottomPlayListState();
}

class _BottomPlayListState extends State<BottomPlayList> {
  @override
List<PlayList> playLists=[];
var video;
  Widget build(BuildContext context) {
    
   if(widget.condition) {
       video=Provider.of<folder_details>(context, listen: false).getvideo(widget.f_index,widget.v_index);
   }
    playLists= Provider.of<PlayList_detail>(context, listen: false).items();
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      child: Column(
       children: [
         Container(child: ListTile(leading: Icon(Icons.create_new_folder_outlined),title: Text("Create Playlist"), onTap: (){
           Navigator.pop(context);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Create_playlist(f_index:widget.f_index,v_index: widget.v_index, condition: widget.condition,passvideo:widget.passvideo);
              },
            );
           },),),
         Flexible(child:
         ListView.builder(
          shrinkWrap: true,
              itemCount: playLists.length,
              itemBuilder: (context, index) {
               return ListTile(leading: Icon(Icons.favorite),title: Text(playLists[index].p_title), 
               onTap:(){
                    Navigator.of(context).pop();
                    //Provider.of<PlayList_detail>(context, listen: false).add_to_palylist(widget.file_detail[widget.v_id],playLists[index].p_title);
                    if(widget.passvideo.isNotEmpty){
                      int c=Provider.of<PlayList_detail>(context, listen: false).copy_playList(playLists[index].p_id,"",widget.passvideo);
                      ScaffoldMessenger.maybeOf(context)!.hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            "$c Video added",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    else{
                       Provider.of<PlayList_detail>(context, listen: false).add_one_playlist(playLists[index].p_id, video);     
                    }
               } 
               );
              })
         )
       ],
      ),
    );
  }
}





      // ListView.builder(
      //       itemCount: playLists.length,
      //       itemBuilder: (context, index) {
      //        return ListTile(leading: Icon(Icons.favorite),title: Text(playLists[index].p_title), 
      //       //  onTap:(){
      //       //       Provider.of<PlayList_detail>(context, listen: true).add_to_palylist(widget.file_detail[widget.v_id],playLists[index].p_title);
      //       //  } ,
             
             
      //        );
      //       })