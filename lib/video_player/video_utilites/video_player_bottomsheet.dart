import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:video/helper/file.dart';
import '../../helper/files.dart';


class video_bottom_sheet extends StatefulWidget {
  final int f_id;
  void Function(int index) playfolder_video;
  video_bottom_sheet({Key? key, required this.f_id, required this.playfolder_video })
      : super(key: key);

  @override
  State<video_bottom_sheet> createState() => _video_bottom_sheetState();
}

class _video_bottom_sheetState extends State<video_bottom_sheet> {
  @override
  Widget iconbutton(IconData icon, Function param1) {
    return SizedBox.fromSize(
      size: Size(56, 56), // button width and height
      child: ClipOval(
        child: Material(
          color: Colors.transparent, // button color
          child: InkWell(
            splashColor: Colors.green, // splash color
            onTap: () {
              param1();
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

  Widget build(BuildContext context) {
    var currqueuelist =
        Provider.of<queue_playerss>(context, listen: true).getqueuevideo();
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: FractionallySizedBox(
          heightFactor: 0.45,
          child: currqueuelist[3].length > 0
              ? Column(
                  children: [
                   Card (
                      child: Container(
                        child: ListTile(
                          contentPadding: EdgeInsets.all(0),
                            leading: iconbutton(Icons.close, () {
                          Navigator.pop(context);
                        },),
                        //Provider.of<folder_details>(context, listen: false).getfolder_name(int )
                        title: Text( Provider.of<folder_details>(context, listen: false).folder_name(widget.f_id), overflow: TextOverflow.ellipsis,maxLines: 1, ),
                        trailing: Row( mainAxisSize: MainAxisSize.min,children: [
                          const Text("Order"),
                          iconbutton(Icons.sort_by_alpha_outlined, (){
                    
                          })
                        ],),
                    
                    
                        ),
                      ),
                    ),
                    Flexible(
                      child: ReorderableListView.builder(
                        shrinkWrap: true,
                        onReorder: (int oldIndex, int newIndex) {
                          Provider.of<queue_playerss>(context, listen: false)
                              .reorederd_quelist(oldIndex, newIndex);
                        },
                        itemCount: currqueuelist[3].length,
                        itemBuilder: (context, index) {
                          return Card(
                            
                              key:
                                  ValueKey(currqueuelist[3][index].v_id),
                              child: ListTile(
                                contentPadding: EdgeInsets.only(left: 12,right: 0),
                                leading: const Icon(Icons.drag_handle),
                                title: Text(
                                  currqueuelist[3][index].v_title,
                                   overflow: TextOverflow.ellipsis,
                                   maxLines: 2,
                                  style: TextStyle(
                                      color: currqueuelist[2] == index
                                          ? Colors.green
                                          : Colors.white),
                                ),
                                trailing:Row (
                                  mainAxisSize: MainAxisSize.min,
                                  
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children :[ 
                                    currqueuelist[2] == index?iconbutton(Icons.play_arrow, () { }):Container(),
                                    iconbutton(Icons.close, () {
                                    Provider.of<queue_playerss>(context,
                                            listen: false)
                                        .remove_from_queue(
                                            currqueuelist[3][index].v_id);
                                  }),
                                  ]
                                ),
                                onTap: (){
                                  widget.playfolder_video(index);
                                  Navigator.of(context).pop();

                                },
                              ),);
                        },
                      ),
                    ),
                  ],
                )
              : Container()),
    );
  }
}
