

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:video/helper/file.dart';

import '../file/files_detail.dart';
import '../helper/files.dart';
import '../helper/storage.dart';
import '../properties/file_bootom_sheet.dart';
import '../properties/bottomsheet_playlist.dart';
import '../showdialogbox/file_delete.dart';

class Video_Home extends StatefulWidget {
 
   Video_Home({Key? key}) : super(key: key);
static const routeName = '/video_Home';
  @override
  State<Video_Home> createState() => _Video_HomeState();
}

class _Video_HomeState extends State<Video_Home> {
 
  @override
  bool selection = false;
  int icons_value = 0;
  List<video> file_detail=[];
  String title ="Video";
  int size=0;

  Map<int,int> selction_list = {};
  int selcted_size = 0;



  void _videoproprties(BuildContext context, int id,int f_id) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: false,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child:Bottom_model(v_id:id,file_detail: file_detail,f_id:f_id,onPressed:_bottoplaylist),
        );
      },
    );
  }


void _bottoplaylist(BuildContext context, int v_index,int f_index) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          // contdition to be ture for one video
          child:BottomPlayList(v_index:v_index, passvideo: [],f_index:f_index,condition: true),
        );
      },
    );
  }


  void toggleselction() {
    setState(() {
      selection = !selection;
    });
  }

  void toggleselctionlist(int value, int size,int p_id) {
    setState(() {
      if(selction_list.containsKey(value)) {
         selction_list.remove(value);
         selcted_size -= size;
      } else {
        selction_list.addAll({value:p_id});
        selcted_size += size;
      }
    });
  }

  Future<void> ondelete() async {
    toggleselction();
    if(selction_list.isNotEmpty) {
      await Provider.of<folder_details>(context,listen: false).delete_file(selction_list);
    }

    selction_list.clear();
  }
  void _select_all_file(List<video> file_path, int size) {
    setState(() {
      if (file_path.length == selction_list.length) {
        selction_list.clear();
        selcted_size = 0;
      } else {
        selction_list.clear();
        file_path.forEach((element) {selction_list.addAll({element.v_id:element.parent_folder_id});});
        selcted_size = size;
      }
    });
  }

  Widget _Popups() {
    return PopupMenuButton(
        itemBuilder: (context) => selection
            ? [
                const PopupMenuItem(
                    child: ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text("Add to fav"),
                )),
                const PopupMenuItem(
                    child: ListTile(
                  leading: Icon(Icons.share),
                  title: Text("share"),
                )),
               PopupMenuItem(
                
                onTap: (){
                },
                  
                    child: ListTile(
                  leading: Icon(Icons.details),
                  title: Text("properties"),
                )
                
                
                ),
              ]
            : [
                PopupMenuItem(
                    onTap: () => toggleselction(),
                    child: ListTile(
                      leading: Icon(Icons.select_all),
                      title: Text("Select"),
                    )),
                const PopupMenuItem(
                    child: ListTile(
                  leading: Icon(Icons.sort),
                  title: Text("sort by"),
                )),
              ]);
  }

  List<Widget> action() {
    return (selection
        ? [
            IconButton(
              onPressed: (() {
                print("file click");
                      
              }),
              icon: Icon(Icons.lock_rounded),
            ),
            IconButton(
              onPressed: (){ showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Delete_file_dialog(ondelete:ondelete);
                    });},
              icon: Icon(Icons.delete),
            ),
            _Popups(),
          ]
        : [
            IconButton(
                onPressed: () {
                  setState(() {
                    switch (icons_value) {
                      case 0:
                        {
                          icons_value = icons_value + 1;
                        }
                        break;

                      case 1:
                        {
                          icons_value = icons_value + 1;
                        }
                        break;
                      case 2:
                        {
                          icons_value = 0;
                        }
                        break;
                    }
                  });
                },
                icon: Icon(icons_value == 0
                    ? Icons.list
                    : icons_value == 1
                        ? Icons.list_alt_rounded
                        : Icons.grid_view_outlined)),
            _Popups(),
          ]);
  }

  AppBar _Appbar(String title) {
    return AppBar(
      leading: selection?new IconButton(
        icon: new Icon(Icons.close),
        onPressed: () =>selection? toggleselction(): Navigator.of(context).pop(),
      ):null,
      title: Text(title),
      actions: action(),
    );
  }

  Widget _listViewbulder(List<video> file_detail) {
    return ListView.builder(
        itemCount: file_detail.length,
        itemBuilder: (context, index) {
          return Files_path(
            index: index,
            file_path: file_detail,
            value: icons_value,
            onPressed: toggleselction,
            selection: selection,
            selction_list: selction_list,
            onPressed1: toggleselctionlist,
            bottommodel:_videoproprties,
          );
        });
  }

  Widget _gridviewbuilder(List<video> file_detail) {
    return GridView.builder(
        itemCount: file_detail.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          return GridTile(
              child: Container(
                  color: Colors.red,
                  child: Center(child: Text(file_detail[index].v_title))));
        });
  }

@override
  void initState() {
    
    super.initState();
    getAllvideos();
  }
  void didChangeDependencies(){
    //getAllvideos();
     super.didChangeDependencies();
  }

  void getAllvideos() {
    setState(() {
      file_detail=Provider.of<folder_details>(context, listen: false).getAllvideo();
        size=Provider.of<folder_details>(context, listen: false).gettotalvideosize();
     
    });
  }
Widget _body(){
  file_detail=Provider.of<folder_details>(context, listen: true).getAllvideo();
  size=Provider.of<folder_details>(context, listen: false).gettotalvideosize();
  return (
    Column(
        children: [
          ListTile(
              title: Text(
                '${file_detail.length} video  ${Storage().getFileSize(size, 1)}',
                style: TextStyle(fontSize: 13),
              ),
              trailing: selection
                  ? Checkbox(
                      value: file_detail.length == selction_list.length,
                      onChanged: (value) {
                        _select_all_file(file_detail, size);
                      })
                  : null),

          Flexible(
            child: 
             icons_value == 0 || icons_value == 1
                ? _listViewbulder(file_detail)
                : _gridviewbuilder(file_detail),
          )
        ],
      )
  );
}
  Widget build(BuildContext context) {
    String selected_title = selction_list.length.toString() + " " + 'selected';
    return Scaffold(
      appBar: _Appbar(selection ? selected_title : title),
     // body: _body(),
    //  body: NestedScrollView(
    //   floatHeaderSlivers: true,
    //   headerSliverBuilder: (context, innerBoxIsScrolled) => [
    //     SliverAppBar(
    //       floating: true,
    //       snap: true,
    //       title: Text(selection ? selected_title : title),
    //       actions: action(),
    //       )
    //   ],
      body: _body());
   // );
  }
}
