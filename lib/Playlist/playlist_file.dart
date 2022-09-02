import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:video/Playlist/video_song_screen/video_and_song_screent.dart';

import '../helper/file.dart';
import '../helper/files.dart';
import '../properties/bottomsheet_playlist.dart';
import '../properties/playlist_video_bootomsheet.dart';
import '../video_player/video_play.dart';
import 'create_playList.dart';

class Playlist_file extends StatefulWidget {
  const Playlist_file({Key? key}) : super(key: key);
  static const routeName = '/Playlist_video';
  @override
  State<Playlist_file> createState() => _Playlist_fileState();
}


class _Playlist_fileState extends State<Playlist_file> {

    List<video> playLists=[];
    String p_title="";
    var p_id;

  void _playlistbootomsheet(BuildContext context, int id,int f_id) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: false,
      context: context,
      backgroundColor: Theme.of(context).backgroundColor,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child:playlistbootoomshet(v_id:id,p_title: p_title,f_id:f_id,onPressed:_bottoplaylist,p_id:p_id,on_delete:ondelete),
        );
      },
    );
  }

  Future<void> ondelete(Map<int,int>delete) async {
    Provider.of<PlayList_detail>(context, listen: false).remove_from_playlist(delete);
  }

void _bottoplaylist(BuildContext context, int v_index,int f_index) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child:BottomPlayList(v_index:v_index,f_index:f_index,condition: true,passvideo: []),
        );
      },
    );
  }

  // void ondelete(Map<int,int> delete){
  //    Provider.of<PlayList_detail>(context, listen: false).remove_playlist_video(delete);
  // }

@override

  @override
  Widget _body() {
    return Column(
      children: [
        Container(
          height: 50,
          child: ListTile(
              leading: Icon(Icons.play_arrow),
              title: Text(
                ' Play',
                style: TextStyle(fontSize: 13),
              ),
              trailing: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).pushNamed(Videos_And_Songs.routeName,
                        arguments: p_title);
                  })),
        ),
        Flexible(
          child: ReorderableListView.builder(
            onReorder: (oldIndex, newIndex) {
              Provider.of<PlayList_detail>(context, listen: false).reorederd_playlist_video(oldIndex, newIndex, p_id);
            },
              itemCount: playLists.length,
              itemBuilder: (context, index) {
                return ListTile(
                  key: ValueKey(index),
                  leading: Icon(Icons.queue_play_next_outlined),
                  title: text(playLists[index].v_title),
                  onTap: (){
                     Provider.of<queue_playerss>(context, listen: false)
                  .add_video_list_in_queue(index, playLists);
                  
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Play_video(
                      f_id: playLists[index].parent_folder_id),
                ),
              );
                  },
                  trailing: IconButton(
                      onPressed: () {
                        _playlistbootomsheet(context,playLists[index].v_id,playLists[index].parent_folder_id);
                      },
                      icon: Icon(Icons.more_vert)),
                );
              }),
        ),
      ],
    );
  }
Widget text(String text){
  return Text(text , style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
           ));
}
  Widget build(BuildContext context) {
    var arg=ModalRoute.of(context)!.settings.arguments as Map;
    p_id=arg['v2'];
    p_title = arg['v1'];
    playLists=Provider.of<PlayList_detail>(context, listen: true).getPlayListWithplay_id(p_id);


    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar( 
            backgroundColor: Theme.of(context).primaryColor,
       
            expandedHeight: 240,
            flexibleSpace: FlexibleSpaceBar(

                // background: Colors.blue,
                ),
            pinned: true,
            floating: true,
            snap: true,
            title: text(p_title),
            // actions: action(),
          ),
        ],
        body: Container(   color: Theme.of(context).backgroundColor,child: _body()),
      ),
    );
  }
}
