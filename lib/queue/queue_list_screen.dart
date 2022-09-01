import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:video/helper/file.dart';

import '../helper/files.dart';

class queue_list extends StatefulWidget {
  final List<video> queue_list_video;
  const queue_list({Key? key, required this.queue_list_video})
      : super(key: key);

  @override
  State<queue_list> createState() => _queue_listState();
}

class _queue_listState extends State<queue_list> {
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

  Widget build(BuildContext context) {
    var currqueuelist =
        Provider.of<queue_playerss>(context, listen: true).getqueuevideo();
    return FractionallySizedBox(
        heightFactor: 0.9,
        child: widget.queue_list_video.length > 0
            ? Column(
                children: [
                  SizedBox(height: 10),
                  Align(
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
                  SizedBox(height: 10),
                  Card(
                    child: Container(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(0),
                        leading: iconbutton(
                          Icons.close,
                          () {
                            Navigator.pop(context);
                          },
                        ),
                        title:
                            Text("playing queue  ${currqueuelist[3].length}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text("Order"),
                            iconbutton(Icons.sort_by_alpha_outlined, () {})
                          ],
                        ),
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
                      itemCount: widget.queue_list_video.length,
                      itemBuilder: (context, index) {
                        return Card(
                            key: ValueKey(widget.queue_list_video[index].v_id),
                            child: ListTile(
                              contentPadding:
                                  EdgeInsets.only(left: 12, right: 0),
                              leading: const Icon(Icons.drag_handle),
                              title: Text(
                                widget.queue_list_video[index].v_title,
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
                                          .remove_from_queue(widget
                                              .queue_list_video[index].v_id);
                                    }),
                                  ]),
                            ));
                      },
                    ),
                  ),
                ],
              )
            : Container());
  }
}
