import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:video/helper/file.dart';

import '../helper/files.dart';
import 'playlist_file.dart';

class PlayList_details extends StatefulWidget {
  final String  p_id;
  void Function(BuildContext context, String p_id) bottmplaysheet;
  PlayList_details({Key? key, required this.p_id, required this.bottmplaysheet })
      : super(key: key);

  @override
  State<PlayList_details> createState() => _PlayList_detailsState();
}

class _PlayList_detailsState extends State<PlayList_details> {
  @override
  Widget text(String text){
  return Text(text , style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
  ));
}
Widget icons(IconData icon){
  return Icon(icon,color:Theme.of(context).iconTheme.color,);
}
  Widget build(BuildContext context) {
  
  String p_title=Provider.of<PlayList_detail>(context, listen: true).getplaylisttitle(widget.p_id);
  String P_file_length=Provider.of<PlayList_detail>(context, listen: true).P_file_length(widget.p_id);

    return ListTile(
      
      leading: Icon(
        Icons.favorite_sharp,
        color:  Theme.of(context).primaryColor
      ),
      title: text(p_title),
      subtitle: text(P_file_length+" Video"),
      trailing: IconButton(onPressed: () {

        widget.bottmplaysheet( context, widget.p_id);

      }
      , icon: icons(Icons.more_vert)),
      onTap: (){ 

          Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Playlist_file(
                          p_id: widget.p_id,
                        )));
      },
    );
  }
}
