import 'dart:io';
import 'dart:typed_data';
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
  Map<String, String> selction_list;
  void Function(String, int, String)? onPressed1;
  bool recent_played=false;
  void Function(BuildContext context, String f_id, String p_id)? bottommodel;
  Future<void> Function(Map<String, String> single_video_list)? onsinglefiledelete;
  final int index;
  Files_path(
      {Key? key,
      this.recent_played=false,
      required this.index,
      required this.file_path,
      required this.value,
      required this.onPressed,
      required this.selection,
      required this.selction_list,
      required this.onPressed1,
      required this.bottommodel,
      this.onsinglefiledelete=null,
      })
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
            onTap: widget.recent_played?(){widget.onsinglefiledelete!({widget.file_path[widget.index].v_id:
                  widget.file_path[widget.index].parent_folder_id});}:  () {
              widget.bottommodel!(context, widget.file_path[widget.index].v_id,
                  widget.file_path[widget.index].parent_folder_id);
            }, // button pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                 widget.recent_played?Icons.close:  Icons.more_vert,
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

 Widget text(String text,{TextStyle? style,double size=16,maxLines,Color? color,FontWeight? weight , TextAlign align= TextAlign.center,}) {
    return Text(text,
    maxLines: maxLines,
    textAlign:align,
    style: style?? TextStyle(
      color:color?? Theme.of(context).textTheme.bodyText1!.color,
      fontSize: size,
      fontWeight: weight,
    //  fontFamily: 'Roboto',
    ),);

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

void update_thumbail(String thum){
  Provider.of<folder_details>(context, listen: false).setthumail(widget.file_path[widget.index].parent_folder_id,widget.file_path[widget.index].v_id, thum);
}

  Widget image() {
    return FutureBuilder(
        future: Createvideothumbail(File(widget.file_path[widget.index].v_videoPath)),
        builder: (context, snapshot) {
          
          if (snapshot.hasData) {
            update_thumbail(snapshot.data.toString());
            return  Image.file(
              File(snapshot.data.toString()),
              height: 64,
              width: 64,
              fit: BoxFit.fill,
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
    return ListTile(
      leading: widget.value == 1
          ? const Icon(
              Icons.folder,
            )
          : widget.file_path[widget.index].v_thumbnailPath!=null&&File(widget.file_path[widget.index].v_thumbnailPath??"null").existsSync()? Image.file(File(widget.file_path[widget.index].v_thumbnailPath ?? "assets/video/video-play-button.png")  ,fit: BoxFit.fill,height: 64,
              width: 64,) :  image(),
  
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
      onTap:  (widget.selection || widget.bottommodel == null) &&
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
            print("tapped");
              Provider.of<queue_playerss>(context, listen: false)
                  .add_video_list_in_queue(widget.index, widget.file_path,f_id: widget.file_path[widget.index].parent_folder_id);
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => Demo_palyer(
              //         v_path: widget.file_path[widget.index].v_videoPath),
              //   ),
              // );
              Navigator.of(context).pushNamed(Play_video.routeName);
             //Demo_palyer( v_path: widget.file_path[widget.index].v_videoPath,);
            },
      onLongPress: widget.onPressed1 != null&&widget.recent_played==false
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
