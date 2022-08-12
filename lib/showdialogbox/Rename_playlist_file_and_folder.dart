import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/Playlist/video_song_screen/video_and_song_screent.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/storage.dart';

import '../Videos/video.dart';
import '../helper/files.dart';

class Rename_playlist_file_and_folder extends StatefulWidget {
  final int v_id;
  final bool condition;
  final int p_id;

  const Rename_playlist_file_and_folder(
      {Key? key,
      required this.p_id,
      required this.v_id,
      required this.condition})
      : super(key: key);
  @override
  State<Rename_playlist_file_and_folder> createState() => _Rename_playlist_file_and_folderState();
}

class _Rename_playlist_file_and_folderState extends State<Rename_playlist_file_and_folder> {
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

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: AlertDialog(
          insetPadding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          scrollable: true,
          title: Text('Rename'),
          content: Container(
            width: MediaQuery.of(context).size.width - 20,
            child: Column(
              children: <Widget>[
                TextFormField(
                  autofocus: true,
                  decoration: InputDecoration(labelText: 'New Name'),
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
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: isEmpty()
                  ? () {
                      Navigator.pop(context);

                      widget.condition
                          ? Provider.of<PlayList_detail>(context, listen: false)
                              .rename_playlist_folder(
                                  widget.p_id, _inputController.text)
                          : Provider.of<PlayList_detail>(context, listen: false)
                              .rename_playlist_video(widget.v_id, widget.p_id,
                                  _inputController.text);
                    }
                  : null,
              child: const Text('Rename'),
            ),
          ],
        ));
  }
}
