import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:video/helper/file.dart';

import '../file/file.dart';

class CharacteristListItem extends StatefulWidget {
  final folder folder_detail;
  final VoidCallback? toggleselction;
  final bool selection;
  Set<int> selction_list;
  void Function(int, int) toggleselctionlist;
  void Function(BuildContext context, int f_Id) bottomsheet;
 // void Function(BuildContext context) queue_list_video;
  CharacteristListItem({
    Key? key,
    required this.bottomsheet,
    required this.folder_detail,
    required this.toggleselction,
    required this.selection,
    required this.selction_list,
    required this.toggleselctionlist, 
    //required this.queue_list_video,
  }) : super(key: key);

  @override
  State<CharacteristListItem> createState() => _CharacteristListItemState();
}

class _CharacteristListItemState extends State<CharacteristListItem> {



  @override
  Widget iconbutton(IconData icon,  Function(BuildContext context, int f_Id) param1) {
    return SizedBox.fromSize(
      size: Size(56, 56), // button width and height
      child: ClipOval(
        child: Material(
          color: Colors.transparent, // button color
          child: InkWell(
            splashColor: Colors.green, // splash color
            onTap: () {
              param1;
            }, // button pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon), // icon
                // text
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget checbox(){
    return Checkbox(
              value: widget.selction_list.contains(widget.folder_detail.f_id),
              onChanged: (value) {
               widget.toggleselctionlist(widget.folder_detail.f_id,widget.folder_detail.f_size);
              });

  }

  Widget iconbutoon(){
    return SizedBox.fromSize(
      size: Size(45, 45), // button width and height
      child: ClipOval(
        child: Material(
          color: Colors.transparent, // button color
          child: InkWell(
            splashColor: Colors.green, // splash color
            onTap: () {
              widget.bottomsheet(context, widget.folder_detail.f_id);
            }, // button pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.more_vert, color: IconTheme.of(context).color,), // icon
                // text
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget build(BuildContext context) {
    return ListTile(
      leading:  Icon(
        Icons.folder,
        color:IconTheme.of(context).color,
      ),
      title: Text(widget.folder_detail.f_title,
          style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
           ),
         ),
      onTap: widget.selection? (){widget.toggleselctionlist(widget.folder_detail.f_id,widget.folder_detail.f_size);}:() {
        Navigator.of(context).pushNamed(Files.routeName, arguments: {
          'v1': widget.folder_detail.f_title,
          'v2': widget.folder_detail.f_id
        }
        );
      },
      trailing: widget.selection?checbox():iconbutoon(),
      onLongPress: (){
        widget.toggleselction!();
        widget.toggleselctionlist(widget.folder_detail.f_id,widget.folder_detail.f_size);

      },
      
    );
  }
}
