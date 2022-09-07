import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/Playlist/video_song_screen/video_and_song_screent.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/storage.dart';

import '../Videos/video.dart';
import '../helper/files.dart';

class Create_playlist extends StatefulWidget {
  final String f_id;
  final String v_id;
  final bool condition;
  final List<video> passvideo;
  const Create_playlist(
      {Key? key,
      required this.passvideo,
      required this.f_id,
      required this.v_id,
      required this.condition})
      : super(key: key);
  @override
  State<Create_playlist> createState() => _Create_playlistState();
}

class _Create_playlistState extends State<Create_playlist> {
  @override
  final TextEditingController _inputController = TextEditingController();
  bool isButtonEnabled = false;
  var video;
  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  bool isEmpty() {
    setState(() {
      if ((_inputController.text.trim().isNotEmpty) &&
          (_inputController != null)) {
        isButtonEnabled = true;
      } else {
        isButtonEnabled = false;
      }
    });
    return isButtonEnabled;
  }
Widget text(String text){
  return Text(text , style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
           ));
}

  Widget build(BuildContext context) {
    if (widget.condition)
      video = Provider.of<folder_details>(context, listen: true)
          .gevideo(widget.f_id, widget.v_id);
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: AlertDialog(
          insetPadding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          scrollable: true,
          title: text(' Create Playlist'),
          content: Container(
            width: MediaQuery.of(context).size.width - 20,
            child: Column(
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(labelText: 'Create Playlist'),
                  controller: _inputController,
                  onChanged: (val) {
                    isEmpty();
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child:  text('Cancel'),
            ),
            TextButton(
              onPressed: isEmpty()
                  ? widget.passvideo.isNotEmpty
                      ? () {
                         Navigator.pop(context);
                          Provider.of<PlayList_detail>(context, listen: false)
                              .create_one_copy_playList(
                                  _inputController.text, widget.passvideo);
                           // Provider.of<folder_details>(context, listen: false).add_to_playlist_id(playLists[index].p_id,widget.condition?[videos]:widget.passvideo);
                          
                        }
                      : widget.condition
                          ? () {
                              Navigator.pop(context);
                              if(Provider.of<PlayList_detail>(context,
                                      listen: false)
                                  .create_add_one_playlist(
                                      _inputController.text, video)){
                                        print("add one to playlist");
                                      }
                                      
                            }
                          : () {
                              Navigator.pop(context);
                              Navigator.of(context).pushNamed(
                                  Videos_And_Songs.routeName,
                                  arguments: _inputController.text);
                            }
                  : null,
              child: text('Create'),
            ),
          ],
        ));
  }
}
