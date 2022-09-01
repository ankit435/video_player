import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/Playlist/video_song_screen/video_and_song_screent.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/storage.dart';

import '../Videos/video.dart';
import '../helper/files.dart';

class Rename_file_folder extends StatefulWidget {
  final int v_id;
  final bool condition;
  final int f_id;

  const Rename_file_folder(
      {Key? key,
      required this.f_id,
      required this.v_id,
      required this.condition})
      : super(key: key);
  @override
  State<Rename_file_folder> createState() => _Rename_file_folderState();
}

class _Rename_file_folderState extends State<Rename_file_folder> {
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
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: AlertDialog(
          insetPadding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          scrollable: true,
          title: text('Rename'),
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
              child: text('Cancel'),
            ),
            TextButton(
              onPressed: isEmpty()
                  ? () {
                      Navigator.pop(context);

                      widget.condition
                          ? Provider.of<folder_details>(context, listen: false)
                              .rename_folder(
                                  widget.f_id, _inputController.text)
                          : Provider.of<folder_details>(context, listen: false)
                              .rename_file(widget.v_id, widget.f_id,
                                  _inputController.text);
                    }
                  : null,
              child: text('Rename'),
            ),
          ],
        ));
  }
}
