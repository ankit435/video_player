







import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/helper/files.dart';
import '../../helper/file.dart';
import 'Tabbar/Playlist_Songs.dart';
import 'Tabbar/playlist_video.dart';



class Videos_And_Songs extends StatefulWidget {
  const Videos_And_Songs({Key? key}) : super(key: key);
  static const routeName = '/Videos_And_Songs';
  @override
  State<Videos_And_Songs> createState() => _Videos_And_SongsState();
}

class _Videos_And_SongsState extends State<Videos_And_Songs> {
  @override

  List<video> file_detail=[];
  int size=0;
  Map<int,int> selction_list = {};
  int selcted_size = 0;
  String p_title="";


List<Widget> action(){
  return [
    IconButton(onPressed: (){ 
      selction_list.isNotEmpty&&p_title.isNotEmpty?add_to_playlist():null; Navigator.of(context).pop();}, icon:const Icon(Icons.check),padding: EdgeInsets.only(right: 5),)
  ];
}

@override



  void add_to_playlist(){
          Provider.of<PlayList_detail>(context, listen: false).playlist_adds(file_detail,p_title,selction_list);
         setState(() {
           selction_list.clear();
         });
         
  }
  void toggleselctionlist(int value, int size,int p_id) {
    setState(() {
      if(selction_list.containsKey(value)) {
         selction_list.remove(value);
         selcted_size -= size;
      } else {
        selction_list.addAll({value:p_id});
        selcted_size += size;
      }
    });
  }
  void _select_all_file() {
    setState(() {
      if (file_detail.length == selction_list.length) {
        selction_list.clear();
        selcted_size = 0;
      } else {
        selction_list.clear();
        file_detail.forEach((element) {selction_list.addAll({element.v_id:element.parent_folder_id});});
        selcted_size = size;
      }
    });
  }
  @override

  // void marked_playlist_video(){
  //   var play_listvideo=Provider.of<PlayList_detail>(context, listen: true).getPlayListWithTitle(p_title);
  //   setState(() {
  //     play_listvideo.forEach((element) { 
  //       selction_list.addAll({element.v_id:element.parent_folder_id});
  //     });
  //   });
  // }
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  
  Widget build(BuildContext context) {
  p_title= ModalRoute.of(context)!.settings.arguments as String;
  file_detail=Provider.of<folder_details>(context, listen: true).getAllvideo();
  size=Provider.of<folder_details>(context, listen: false).gettotalvideosize();

    return DefaultTabController (
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            floating: true,
            snap: true,
            title: Text(selction_list.length.toString() +" Selected"),
            actions: action(),
            bottom: TabBar(tabs: [Tab(text: "Song",),Tab(text: "Video",)]),
            ),
        ],
        body:  TabBarView(children: [
          Song_playlist(),
          Video_playlist( selction_list: selction_list,
            toggleselctionlist: toggleselctionlist,Files_path:file_detail, select_all_file:_select_all_file),
        ],),
    
      ),
    )
    );



// ignore: dead_code
}


}
