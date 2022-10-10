



import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/helper/file.dart';

import '../../Music_player/Music_play_screent.dart';
import '../../helper/files.dart';

class Songs extends StatefulWidget {
  void Function(BuildContext context, String? path) music_plyers_screen;
   Songs({Key? key, required  this.music_plyers_screen}) : super(key: key);

  @override
  State<Songs> createState() => _SongsState();
}

class _SongsState extends State<Songs> {
  List<Music>Music_list=[];
  @override
   Widget text(String text,{TextStyle? style,double size=16,maxLines,Color? color,FontWeight? weight , TextAlign align= TextAlign.start,}) {
    return AutoSizeText(text,
    maxLines: maxLines,
    textAlign:align,
    overflow: TextOverflow.ellipsis,
    style: style?? TextStyle(
      color:color?? Theme.of(context).textTheme.bodyText1!.color,
      fontSize: size,
      fontWeight: weight,
    //  fontFamily: 'Roboto',
    ),);

  }
    Widget icons(IconData icon) {
    return Icon(
      icon,
      color: Theme.of(context).iconTheme.color,
    );
  }
  @override
  Widget build(BuildContext context) {
    Music_list= Provider.of<folder_details>(context, listen: true).get_all_music();
  
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
      color: Theme.of(context).backgroundColor, 

      child : RefreshIndicator (
      onRefresh: (){ Provider.of<folder_details>(context, listen: false).fetchdatabase(); return Future.delayed(const Duration(seconds: 1));},
        child: ListView.builder( padding: EdgeInsets.zero, itemBuilder:((context, index){
        return ListTile( leading: icons(Icons.music_note), title: text(Music_list[index].m_title,maxLines: 2),
        onTap: (){
         
         // Navigator.of(context).push(MaterialPageRoute(builder: (context) => Music_play_screen(m_id: Music_list[index].m_id,p_id: Music_list[index].m_f_id,m_path:Music_list[index].m_path,)));
        widget.music_plyers_screen(context,Music_list[index].m_path);
        },

        );
         })
        ,itemCount: Music_list.length,),
      ));});
  }
}