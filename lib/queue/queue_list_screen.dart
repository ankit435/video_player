import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15 ),
      child: Container(
          height: MediaQuery.of(context).size.height / 2,
          child: ReorderableListView.builder(
             onReorder: (int oldIndex, int newIndex) { 
              Provider.of<queue_playerss>(context, listen: false).reorederd_quelist(oldIndex, newIndex);
              },
            
              itemCount: widget.queue_list_video.length,
              itemBuilder: (context, index) {
                return Card( key: ValueKey(widget.queue_list_video[index].v_id), child: ListTile(leading: const Icon(Icons.drag_handle), title: Text(widget.queue_list_video[index].v_title),));
              }, ),),
    );
  }
}
