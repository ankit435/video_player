

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:video/helper/file.dart';

import '../helper/files.dart';

class Manage_scan_list extends StatefulWidget {
  static const routeName = '/Manage_scan_list';
  const Manage_scan_list({Key? key}) : super(key: key);

  @override
  State<Manage_scan_list> createState() => _Manage_scan_listState();
}

class _Manage_scan_listState extends State<Manage_scan_list> {

 List<folder> folder_list=[];
      Widget text(String text,{TextStyle?style}) {
    return Text(text,
        style: style ?? TextStyle(
          color: Theme.of(context).textTheme.bodyText1!.color,
        ) );
  }
  
  Widget icons(IconData icon) {
    return Icon(
      icon,
      color: Theme.of(context).iconTheme.color,
    );
  }

  Widget video_folder(){
    return ListView.builder(itemBuilder: (context, index) {
      return ListTile(
        title: text(folder_list[index].f_title),
        subtitle: text(folder_list[index].f_path, style: TextStyle(decoration:folder_list[index].show? TextDecoration.lineThrough:null),),
        trailing: IconButton(onPressed: (){

          setState(() {
            Provider.of<folder_details>(context, listen: false).toggle_show_folder(folder_list[index].f_path);
          });

        }, icon: icons( folder_list[index].show?Icons.hide_source:Icons.visibility)),
      );
    
    } , itemCount: folder_list.length, padding: EdgeInsets.zero,);
  }
  Widget song_folder(){
    return Container(color: Colors.amber,);
  }
  @override
  Widget build(BuildContext context) {
  folder_list= Provider.of<folder_details>(context, listen: true).items();
   return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Container(
            color: Theme.of(context).backgroundColor,
            child: NestedScrollView(
   
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                SliverAppBar(
                  backgroundColor: Theme.of(context).backgroundColor,
                  pinned: true,
                  floating: true,
                  snap: true,
                  title: text("Manage Scan List"),
                 // actions: action(),
                  bottom:Provider.of<Setting_data>(context,listen: true).get_setting_show_music()? TabBar(tabs: [
                    Tab(
                      child: text("Video") ,
                      //text: "Song",
                      
                    ),
                    Tab(
                     child: text("Song") ,
                    )
                  ]):null
                ),
              ],
              body: TabBarView(
                children: [
                  video_folder(),
                  song_folder(),
                ],
              ),
          ),
        )));

  }
}