


import 'package:auto_size_text/auto_size_text.dart';
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

  void _bottomsheetdetail(BuildContext context, String p_id) {
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
          child: PlayListfolder_add(
              p_id: p_id, onPressed: _bottoplaylist, on_delete: ondelete),
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement init
      Provider.of<PlayList_detail>(context, listen: false).fetchdatabase();
    super.initState();
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
              v_id: "-1",
              f_id: "-1",
              passvideo: playLists[p_index].p_detail,
              condition: false),
        );
      },
    );
  }

  Future<void> ondelete(Set<String> p_id) async {
    Provider.of<PlayList_detail>(context, listen: false)
        .remove_playlist_folder(p_id);
  }

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

  Widget _body() {
    return Column(children: [
      Container(
        height: 50,
        child: ListTile(
            title: Text(
              '  ${playLists.length} Playlists',
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).primaryColor,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.add,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Create_playlist(
                        f_id: "-1",
                        v_id: "-1",
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
                  Provider.of<PlayList_detail>(context, listen: false)
                      .reorederd_playlist_Folder(oldIndex, newIndex)
                }),
            itemCount: playLists.length,
            itemBuilder: (context, index) {
              return PlayList_details(
                  key: ValueKey(index),
                  p_id: playLists[index].p_id,
                  bottmplaysheet: _bottomsheetdetail);
            }),
      )
    ]);
  }

  Widget build(BuildContext context) {
    playLists = Provider.of<PlayList_detail>(context, listen: true).items();
    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              // pinned: true,
              floating: true,
              snap: true,
              title: text("PlayList"),
              // actions: action(),
            ),
          ],
          body:
              Container(color: Theme.of(context).backgroundColor, child: _body()),
        ),
      ),
    );
  }
}
