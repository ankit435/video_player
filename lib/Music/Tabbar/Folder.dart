



import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/files.dart';

class Folders extends StatefulWidget {
  const Folders({Key? key}) : super(key: key);
 

  @override
  State<Folders> createState() => _FoldersState();
}

class _FoldersState extends State<Folders> {
   List<folder>folder_list=[];
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
  Widget build(BuildContext context) {
      folder_list = Provider.of<folder_details>(context, listen: true).Music_item();
     return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
      color: Theme.of(context).backgroundColor, 

      child : RefreshIndicator (
      onRefresh: (){ Provider.of<folder_details>(context, listen: false).fetchdatabase(); return Future.delayed(const Duration(seconds: 1));},
        child: ListView.builder( padding: EdgeInsets.zero, itemBuilder:((context, index){
        return ListTile( leading: icons(Icons.folder), title: text("${folder_list[index].f_title} ${folder_list[index].f_music.length}" ),);
         })
        ,itemCount: folder_list.length,),
      ));});
  
  }
}