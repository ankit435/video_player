import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../helper/file.dart';
import '../helper/files.dart';
import '../helper/storage.dart';
import '../video_player/video_play.dart';

class Grid_view_file extends StatefulWidget {
  final int value;
  List<video> file_path;
  final VoidCallback? onPressed;
  final bool selection;
  Map<String, String> selction_list;
  void Function(String, int, String)? onPressed1;
  void Function(BuildContext context, String id, String p_id)? bottommodel;
  final int index;
  Grid_view_file(
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
  State<Grid_view_file> createState() => _Grid_view_fileState();
}

class _Grid_view_fileState extends State<Grid_view_file> {
  @override

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
  void update_thumbail(String thum){
  Provider.of<folder_details>(context, listen: false).setthumail(widget.file_path[widget.index].parent_folder_id,widget.file_path[widget.index].v_id, thum);
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
   Widget text(String text) {
    return Text(text,
    maxLines: 2,
    overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).textTheme.bodyText1!.color,
        ));
  }
  Future<Directory> video_thumbail() async{
  //var dir = await getExternalStorageDirectory();
  //var path = dir?.path;
  var directory = Directory("/storage/emulated/0/.neo_player/");
  if (!await directory.exists()) {
    await directory.create();
  }
  return directory;
}

Future<String?> Createvideothumbail(File path) async{
 
  var dir = await video_thumbail();
  var thumbnail = await VideoThumbnail.thumbnailFile(
    video: path.path,
    thumbnailPath: dir.path,
    imageFormat: ImageFormat.JPEG,
    quality: 75,
  );
  
  return thumbnail;
 

}

  Widget image() {
    return FutureBuilder(
        future: Createvideothumbail(File(widget.file_path[widget.index].v_videoPath)),
        builder: (context, snapshot) {
          
          if (snapshot.hasData) {
              update_thumbail(snapshot.data.toString());
            return  Image.file(
              File(snapshot.data.toString()),
              fit: BoxFit.cover,
            );
            
          } else {
            return Image.asset(
              "assets/video/video-play-button.png",
              fit: BoxFit.fill,
            );
          }
        });
  }
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: (widget.selection || widget.bottommodel == null) &&
                widget.onPressed1 != null
            ? () {
                widget.onPressed1!(
                    widget.file_path[widget.index].v_id,
                    widget.file_path[widget.index].v_size,
                    widget.file_path[widget.index].parent_folder_id);
              }
            : () {

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

        onDoubleTap: (){
            widget.bottommodel!(context, widget.file_path[widget.index].v_id,
                  widget.file_path[widget.index].parent_folder_id);
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
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
          widget.file_path[widget.index].v_thumbnailPath!=null&&File(widget.file_path[widget.index].v_thumbnailPath??"null").existsSync()? Image.file(File(widget.file_path[widget.index].v_thumbnailPath ?? "assets/video/video-play-button.png")  ,fit: BoxFit.fill,height: 60,) :  image(),
          ListTile(
            title: text(widget.file_path[widget.index].v_title),
            subtitle:  FittedBox(
              child:widget.selection? Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 text(Storage().getFileSize(
                          widget.file_path[widget.index].v_size, 1)),
                checkbox()
                
                ],
              ):null
            )
          )
            ],
          ),
        ),
      ),
    );
  }
}
