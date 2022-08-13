import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/storage.dart';

import '../file/file.dart';
import '../helper/files.dart';
import '../video_player/video_play.dart';

class Files_path extends StatefulWidget {
  final int value;
  List<video> file_path;
  final VoidCallback? onPressed;
  final bool selection;
  Map<int, int> selction_list;
  void Function(int, int, int)? onPressed1;
  void Function(BuildContext context, int id, int p_id)? bottommodel;
  final int index;

  // List<String> folder_file_path = [];
  Files_path(
      {Key? key,
      required this.index,
      required this.file_path,
      required this.value,
      required this.onPressed,
      required this.selection,
      required this.selction_list,
      required this.onPressed1,
      required this.bottommodel})
      : super(key: key);
  @override
  State<Files_path> createState() => _CharacteristListItemState();
}

class _CharacteristListItemState extends State<Files_path> {
  Widget checkbox() {
    return Checkbox(
      value:
          widget.selction_list.containsKey(widget.file_path[widget.index].v_id),
      onChanged: (value) {
        widget.onPressed1!(
            widget.file_path[widget.index].v_id,
            widget.file_path[widget.index].v_size,
            widget.file_path[widget.index].parent_folder_id);
      },
    );
  }

  Widget iconbutton() {
    return SizedBox.fromSize(
      size: Size(45, 45), // button width and height
      child: ClipOval(
        child: Material(
          color: Colors.transparent, // button color
          child: InkWell(
            splashColor: Colors.green, // splash color
            onTap: () {
              widget.bottommodel!(context, widget.file_path[widget.index].v_id,
                  widget.file_path[widget.index].parent_folder_id);
            }, // button pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.more_vert), // icon
                // text
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget linearprogress() {
    return LinearProgressIndicator(
      backgroundColor: Colors.red,
      valueColor: AlwaysStoppedAnimation<Color>(
        Colors.green,
      ),
      value: widget.file_path[widget.index].v_duration == 0
          ? 0
          : widget.file_path[widget.index].v_watched /
              widget.file_path[widget.index].v_duration,
    );
  }

  Widget subtitle() {
    return !widget.file_path[widget.index].v_open
        ? const Text(
            "New",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          )
        : linearprogress();
  }

  Widget titles() {
    return AutoSizeText(
      widget.file_path[widget.index].v_title,
      maxLines: 2,
      minFontSize: 13,
      maxFontSize: 18,
      //overflow: TextOverflow.ellipsis
    );
  }

  Widget build(BuildContext context) {
    return ListTile(
      leading: widget.value == 1
          ? const Icon(
              Icons.folder,
            )
          : null,
      title: titles(),
      subtitle: widget.onPressed1 == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: !widget.selection
                  ? subtitle()
                  : widget.selection
                      ? Text(Storage().getFileSize(
                          widget.file_path[widget.index].v_size, 1))
                      : null,
            ),
      trailing: (widget.selection || widget.bottommodel == null) &&
              widget.onPressed1 != null
          ? checkbox()
          : iconbutton(),
      onTap: (widget.selection || widget.bottommodel == null) &&
              widget.onPressed1 != null
          ? () {
              widget.onPressed1!(
                  widget.file_path[widget.index].v_id,
                  widget.file_path[widget.index].v_size,
                  widget.file_path[widget.index].parent_folder_id);
            }
          : () {
              // file dettai pass to context of video;
             Provider.of<queue_playerss>(context, listen: false).add_video_list_in_queue(widget.index, widget.file_path);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Play_video(file: widget.file_path, index: widget.index),
                ),
              );
            },
      onLongPress: widget.onPressed1 != null ? widget.onPressed : null,
    );
  }
}
