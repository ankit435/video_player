import 'dart:io';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:video/helper/file.dart';
import 'package:video/helper/storage.dart';
import 'package:video/helper/theme_model.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

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



  Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Theme.of(context).colorScheme.primary.withOpacity(0.12);
      }
      return  Theme.of(context).primaryColor.withOpacity(0.9);
    }

  Widget checkbox() {
    return Checkbox(
    
     checkColor: Theme.of(context).textTheme.bodyText1!.color,
     fillColor: MaterialStateProperty.resolveWith(getColor),
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
                Icon(
                  Icons.more_vert,
                  color: IconTheme.of(context).color,
                ), // icon
                // text
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget linearprogress() {
    // SharedPreferences prefs = SharedPreferences.getInstance() as SharedPreferences;
    // print(prefs.getInt(widget.file_path[widget.index].v_videoPath));
    return LinearProgressIndicator(
      backgroundColor: Colors.red,
      valueColor: AlwaysStoppedAnimation<Color>(
        Colors.green,
      ),
      value: widget.file_path[widget.index].v_duration == 0
          ? 0
          : widget.file_path[widget.index].v_watched/
              widget.file_path[widget.index].v_duration,
    );
  }

  Widget subtitle() {
    return !widget.file_path[widget.index].v_open
        ? Text(
            "New",
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          )
        : linearprogress();
  }

  Widget titles() {
    return AutoSizeText(widget.file_path[widget.index].v_title,
        maxLines: 2,
        minFontSize: 13,
        maxFontSize: 18,
        style: Theme.of(context).textTheme.bodyText1,
        overflow: TextOverflow.ellipsis);
  }

  Widget text(String text) {
    return Text(text,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyText1!.color,
        ));
  }

  Widget build(BuildContext context) {
//   uint8list= VideoThumbnail.thumbnailData(
//   video: widget.file_path[widget.index].v_videoPath,
//   imageFormat: ImageFormat.JPEG,
//   maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
//   quality: 25,
// );
    return ListTile(
      leading: widget.value == 1
          ? const Icon(
              Icons.folder,
            )
          // : _controller!.value.isInitialized?
          : Container(child: FittedBox (child: Image(image: AssetImage("assets/video/video-play-button.png"),fit: BoxFit.cover,height: 50,width: 50,))),
      //: CircularProgressIndicator(),
      title: titles(),
      subtitle: widget.onPressed1 == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: !widget.selection
                  ? subtitle()
                  : widget.selection
                      ? text(Storage().getFileSize(
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
              //  print(widget.index);

              Provider.of<queue_playerss>(context, listen: false)
                  .add_video_list_in_queue(widget.index, widget.file_path,f_id: widget.file_path[widget.index].parent_folder_id);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => Play_video(
              //         f_id: widget.file_path[widget.index].parent_folder_id),
              //   ),
              // );
              Navigator.of(context).pushNamed(Play_video.routeName);
            },
      onLongPress: widget.onPressed1 != null
          ? () {
              widget.onPressed!();
              widget.onPressed1!(
                  widget.file_path[widget.index].v_id,
                  widget.file_path[widget.index].v_size,
                  widget.file_path[widget.index].parent_folder_id);
            }
          : null,
    );
  }
}
