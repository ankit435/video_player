import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video/helper/file.dart';

import 'playlist_file.dart';

class PlayList_details extends StatefulWidget {
  final PlayList playLists;
  final int index;
  void Function(BuildContext context, int p_id) bottmplaysheet;
  PlayList_details({Key? key, required this.index, required this.playLists, required this.bottmplaysheet })
      : super(key: key);

  @override
  State<PlayList_details> createState() => _PlayList_detailsState();
}

class _PlayList_detailsState extends State<PlayList_details> {
  @override
  Widget build(BuildContext context) {
    
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      leading: Icon(
        Icons.favorite_sharp,
        color: Colors.red,
      ),
      title: Text(widget.playLists.p_title),
      subtitle: Text(widget.playLists.p_detail.length.toString()+" "+"Video"),
      trailing: IconButton(onPressed: () {

        widget.bottmplaysheet( context, widget.playLists.p_id);

      }
      , icon: Icon(Icons.more_vert)),
      onTap: (){Navigator.of(context).pushNamed(Playlist_file.routeName,arguments:{'v1':widget.playLists.p_title,'v2':widget.playLists.p_id});},
    );
  }
}
