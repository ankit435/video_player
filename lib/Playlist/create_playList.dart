import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/Playlist/video_song_screen/video_and_song_screent.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/storage.dart';

import '../Videos/video.dart';
import '../helper/files.dart';

class Create_playlist extends StatefulWidget {
  final int f_index;
  final int v_index;
  final bool condition;
  final List<video> passvideo;
  const Create_playlist(
      {Key? key,
      required this.passvideo,
      required this.f_index,
      required this.v_index,
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
          .getvideo(widget.f_index, widget.v_index);
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
                        }
                      : widget.condition
                          ? () {
                              Navigator.pop(context);
                              Provider.of<PlayList_detail>(context,
                                      listen: false)
                                  .create_add_one_playlist(
                                      _inputController.text, video);
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
