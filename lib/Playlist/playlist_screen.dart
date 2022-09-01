import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/file.dart';
import '../helper/files.dart';
import '../properties/bottomsheet_playlist.dart';
import '../properties/playlist_folder_add.dart';
import 'Playlist_detail.dart';
import 'create_playList.dart';

class Playlist_Screen extends StatefulWidget {
  const Playlist_Screen({Key? key}) : super(key: key);

  @override
  State<Playlist_Screen> createState() => _Playlist_ScreenState();
}

class _Playlist_ScreenState extends State<Playlist_Screen> {
  @override
  List<PlayList> playLists = [];

  void _bottomsheetdetail(BuildContext context, int p_id) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      backgroundColor: Theme.of(context).backgroundColor,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: PlayListfolder_add(p_id: p_id, onPressed: _bottoplaylist),
        );
      },
    );
  }

  void _bottoplaylist(BuildContext context, int p_index) {
    
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      backgroundColor: Theme.of(context).backgroundColor,
      builder: (context) {

        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          // passed playlist id videos
          child: BottomPlayList(
              v_index: -1,
              f_index: -1,
              passvideo: playLists[p_index].p_detail,
              condition: false),
        );
      },
    );
  }

Widget text(String text){
  return Text(text , style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
           ));
}
  Widget _body() {
    return Column(children: [
      Container(
        height: 50,
        child: ListTile(
            title: Text(
              '  ${playLists.length} Playlists',
              style: TextStyle(fontSize: 13),
            ),
            trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Create_playlist(
                        f_index: -1,
                        v_index: -1,
                        condition: false,
                       passvideo: [],
                      );
                    });
              },
            )),
      ),
      Flexible(
        child: ReorderableListView.builder(
          onReorder: ((oldIndex, newIndex) => {
            
          }),
            itemCount: playLists.length,
            itemBuilder: (context, index) {

              return PlayList_details(
                  key:ValueKey(playLists[index].p_id) ,
                  index: index,
                  playLists: playLists[index],
                  bottmplaysheet: _bottomsheetdetail);
            }),
      )
    ]);
  }

  Widget build(BuildContext context) {
    playLists = Provider.of<PlayList_detail>(context, listen: true).items();
    return Scaffold(
      
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar( 
            backgroundColor: Theme.of(context).primaryColor,
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            // pinned: true,
            floating: true,
            snap: true,
            title: text("PlayList"),
            // actions: action(),
          ),
        ],
        body: Container(   color: Theme.of(context).backgroundColor,child: _body()),
      ),
    );
  }
}
