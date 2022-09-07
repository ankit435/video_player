import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:video/helper/file.dart';
import '../../helper/files.dart';

class video_bottom_sheet extends StatefulWidget {
  final String? f_id;
  final String? p_id;
  void Function(int index) playfolder_video;
  video_bottom_sheet(
      {Key? key,
      this.f_id = null,
      required this.playfolder_video,
      this.p_id = null})
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
                Icon(icon, color:IconTheme.of(context).color,), // icon
                // text
              ],
            ),
          ),
        ),
      ),
    );

  }
  Widget text(String text){
  return Text(text ,maxLines: 1, style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
               overflow: TextOverflow.ellipsis,
                              
           ));
}
  Widget build(BuildContext context) {
    var currqueuelist =
        Provider.of<queue_playerss>(context, listen: true).getqueuevideo();
    String? title = widget.f_id != null
        ? Provider.of<folder_details>(context, listen: false)
            .folder_name(widget.f_id)
        : Provider.of<PlayList_detail>(context, listen: false)
            .playlis_title(widget.p_id);
    return FractionallySizedBox(
        heightFactor: 0.45,
        child: currqueuelist[3].length > 0
            ? Column(
                children: [
                   SizedBox(height: 10),
                Align(
                   alignment: Alignment.topCenter,
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    width: 60,
                  ),
                ),
                
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   // mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            iconbutton(Icons.close, () {
                              Navigator.of(context).pop();
                            }),
                            text(
                              title == null ? "Queue" : title,
                             
                            )
                          ]
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                         text("Order"),
                          iconbutton(Icons.sort_by_alpha_outlined, () {})
                        ],
                      ),
                    ],
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
                        return ListTile(
                          key: ValueKey(currqueuelist[3][index].v_id),
                          contentPadding:
                              EdgeInsets.only(left: 12, right: 0),
                          leading: iconbutton(Icons.drag_handle,(){}),
                          title: Text(
                            currqueuelist[3][index].v_title,
                           overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  color: currqueuelist[2] == index
                                      ?Theme.of(context).primaryColor
                                      :  Theme.of(context).textTheme.bodyText1!.color,),
                            ),
                          trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                currqueuelist[2] == index
                                    ? iconbutton(Icons.play_arrow, () {})
                                    : Container(),
                                iconbutton(Icons.close, () {
                                  Provider.of<queue_playerss>(context,
                                          listen: false)
                                      .remove_from_queue(
                                          currqueuelist[3][index].v_id);
                                }),
                              ]),
                          onTap: () {
                            widget.playfolder_video(index);
                            Navigator.of(context).pop();
                          },
                        );
                      },
                    ),
                  ),
                ],
              )
            : Container());
  }
}
