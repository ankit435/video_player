
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/Playlist/create_playList.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/files.dart';


class BottomPlayList extends StatefulWidget {


  final String v_id;
  final String f_id;
  final bool condition;
  final List<video> passvideo;
  const BottomPlayList({Key? key, required this.v_id, required this.f_id,required this.condition,required this.passvideo})
      : super(key: key);

  @override
  State<BottomPlayList> createState() => _BottomPlayListState();
}

class _BottomPlayListState extends State<BottomPlayList> {
  @override

  Widget icons(IconData icon){
  return Icon(icon,color:Theme.of(context).secondaryHeaderColor,);
}
List<PlayList> playLists=[];
late video videos;
  Widget build(BuildContext context) {
    
   if(widget.condition) {
     videos=Provider.of<folder_details>(context, listen: false).gevideo(widget.f_id, widget.v_id);
   }
    playLists= Provider.of<PlayList_detail>(context, listen: false).items();
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.9),
      child: Column(
       children: [
        SizedBox(height:10),

        
        Align(child:Container(height: 10,width: 60,
         decoration: BoxDecoration(
          color: Colors.red,
      borderRadius: BorderRadius.all(
      Radius.circular(5),
      ),
        ),
        ),),
        
         Container(child: ListTile(leading: icons(Icons.create_new_folder_outlined),title: Text("Create Playlist"), onTap: (){
           Navigator.pop(context);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Create_playlist(f_id:widget.f_id,v_id: widget.v_id, condition: widget.condition,passvideo:widget.passvideo);
              },
            );
           },),),
         Flexible(child:
         ListView.builder(
          shrinkWrap: true,
              itemCount: playLists.length,
              itemBuilder: (context, index) {
               return ListTile(leading: icons(Icons.favorite),title: Text(playLists[index].p_title), 
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
                       Provider.of<PlayList_detail>(context, listen: false).add_one_playlist(playLists[index].p_id, videos);     
                    }
                   Provider.of<folder_details>(context, listen: false).add_to_playlist_id(playLists[index].p_id,widget.condition?[videos]:widget.passvideo);
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
      //        return ListTile(leading: icons(Icons.favorite),title: Text(playLists[index].p_title), 
      //       //  onTap:(){
      //       //       Provider.of<PlayList_detail>(context, listen: true).add_to_palylist(widget.file_detail[widget.v_id],playLists[index].p_title);
      //       //  } ,
             
             
      //        );
      //       })