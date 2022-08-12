



import 'package:flutter/material.dart';

import '../../../file/files_detail.dart';
import '../../../helper/file.dart';


class Video_playlist extends StatefulWidget {
   Map<int, int> selction_list;
  List<video> Files_path;
  final VoidCallback select_all_file;
  void Function(int, int, int) toggleselctionlist;
  Video_playlist({Key? key,required this.Files_path,required this.toggleselctionlist,required this.selction_list,required this.select_all_file}) : super(key: key);

  @override
  State<Video_playlist> createState() => _Video_playlistState();
}

  @override


class _Video_playlistState extends State<Video_playlist> {
  @override
 
  
  Widget _listViewbulder() {
    return ListView.builder(
        itemCount: widget.Files_path.length,
        itemBuilder: (context, index) {
          return Files_path(
            index: index,
            file_path: widget.Files_path,
            value: 0,
            onPressed: null,
            selection: false,
            selction_list: widget.selction_list,
            onPressed1:widget.toggleselctionlist,
            bottommodel:null,
          );
        });
  }


  Widget _body(){

  return (
    Column(
        children: [
          Container(
            height: 50,
           
            child: ListTile(
                title: Text(
                  'Select All',
                  style: TextStyle(fontSize: 13),
                ),
                trailing: Checkbox(
                        value: widget.Files_path.length == widget.selction_list.length,
                        onChanged: (value) {
                          widget.select_all_file();
                        })
                    ),
          ),

          Flexible(
            child: 
             _listViewbulder(),
          )
        ],
      )
  );
}

  Widget build(BuildContext context) {
    return _body();
  }
}