

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:video/helper/file.dart';

import '../file/files_detail.dart';
import '../file/grid_view.dart';
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

  Map<String,String> selction_list = {};
  int selcted_size = 0;



  void _videoproprties(BuildContext context, String v_id,String f_id) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: false,
      context: context,
      backgroundColor: Theme.of(context).backgroundColor,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child:Bottom_model(v_id:v_id,file_detail: file_detail,f_id:f_id,onPressed:_bottoplaylist,onsinglefiledelete:onsinglefiledelete),
        );
      },
    );
  }

Widget text(String text){
  return Text(text , style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
           ));
}

void remove_playlist(Map<String,Set<String>> removeList){

  removeList.forEach((key, value) { 
    value.forEach((element) { 
      Provider.of<PlayList_detail>(context, listen: false).remove_from_playlist({key:element});
    });
  });
  
}

  Future<void> ondelete() async {
    if (selction_list.isNotEmpty) {
     Map<String,Set<String>> removeList=await Provider.of<folder_details>(context, listen: false)
          .delete_file(selction_list);
          remove_playlist(removeList);
    }
    toggleselction();
    selction_list.clear();
  }


 Future<void> onsinglefiledelete(Map<String,String>single_video_list) async {

    if (single_video_list.isNotEmpty) {
        Map<String,Set<String>> removeList=await Provider.of<folder_details>(context, listen: false)
          .delete_file(selction_list);
        remove_playlist(removeList);
        
     
    }
  }
void _bottoplaylist(BuildContext context, String v_id,String f_id) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      backgroundColor: Theme.of(context).backgroundColor,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          // contdition to be ture for one video
          child:BottomPlayList(v_id:v_id, passvideo: [],f_id:f_id,condition: true),
        );
      },
    );
  }


  void toggleselction() {
    setState(() {
      selection = !selection;
    });
  }

  void toggleselctionlist(String value, int size,String p_id) {
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
  Widget icons(IconData icon){
  return Icon(icon,color:Theme.of(context).iconTheme.color,);
}

  Widget _Popups() {
    return PopupMenuButton(
      icon: icons(Icons.more_vert),
      color:  Theme.of(context).backgroundColor,

        itemBuilder: (context) => selection
            ? [
                 PopupMenuItem(
                    child: ListTile(
                  leading: icons(Icons.favorite),
                  title: text("Add to fav"),
                )),
                 PopupMenuItem(
                    child: ListTile(
                  leading: icons(Icons.share),
                  title: text("share"),
                )),
               PopupMenuItem(
                
                onTap: (){
                },
                  
                    child: ListTile(
                  leading: icons(Icons.details),
                  title: text("properties"),
                )
                
                
                ),
              ]
            : [
                PopupMenuItem(
                    onTap: () => toggleselction(),
                    child: ListTile(
                      leading: icons(Icons.select_all),
                      title: text("Select"),
                    )),
                 PopupMenuItem(
                    child: ListTile(
                  leading: icons(Icons.sort),
                  title: text("sort by"),
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
              icon: icons(Icons.lock_rounded),
            ),
            IconButton(
              onPressed: (){ showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Show_dialog(onPressedtext:"Delete",onPressed:ondelete,title: "Delete Video from Device",text: "Are you sure you want to delete ${selction_list.length} File?",);
                    });},
              icon: icons(Icons.delete),
            ),
            _Popups(),
            Padding(padding: EdgeInsets.only(left: 15)),
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
                icon: icons(icons_value == 0
                    ? Icons.list
                    : icons_value == 1
                        ? Icons.list_alt_rounded
                        : Icons.grid_view_outlined)),
            _Popups(),
            Padding(padding: EdgeInsets.only(left: 15)),
          ]);
  }

  AppBar _Appbar(String title) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).backgroundColor,
      leading: selection?IconButton(
        icon: icons(Icons.close),
        onPressed: () =>selection? toggleselction(): Navigator.of(context).pop(),
      ):null,
      title: text(title),
      actions: action(),
    );
  }

  Widget _listViewbulder(List<video> file_detail) {
    return ListView.builder(
      padding: EdgeInsets.zero,
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

Widget _gridviewbuilder(List<video> File_path) {
    print(MediaQuery.of(context).size.width);
    return GridView.builder(
      itemCount: File_path.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: (MediaQuery.of(context).size.width/125.0).toInt(), childAspectRatio: 1/1.2,),
      itemBuilder: (context, index) {
        return GridTile(
            child: Grid_view_file( file_path: File_path,
            index: index,
            value: icons_value,
            onPressed: toggleselction,
            selection: selection,
            selction_list: selction_list,
            onPressed1: toggleselctionlist,
            bottommodel: _videoproprties,));
            
            // Container(
            //     color: Colors.red,
            //     child: Center(child: text(File_path[index].v_title)))
                
                
      },
    );
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


Widget _body(){
  file_detail=Provider.of<folder_details>(context, listen: true).getAllvideo();
  size=Provider.of<folder_details>(context, listen: false).gettotalvideosize();
  print(file_detail.length);
  return (
    Column(
        children: [
          ListTile(
              title: text(
                '${file_detail.length} video  ${Storage().getFileSize(size, 1)}',
                //style: TextStyle(fontSize: 13),
              ),
              trailing: selection
                  ? Checkbox(
                     checkColor: Theme.of(context).textTheme.bodyText1!.color,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _Appbar(selection ? selected_title : title),
     // body: _body(),
    //  body: NestedScrollView(
    //   floatHeaderSlivers: true,
    //   headerSliverBuilder: (context, innerBoxIsScrolled) => [
    //     SliverAppBar(
    //       floating: true,
    //       snap: true,
    //       title: text(selection ? selected_title : title),
    //       actions: action(),
    //       )
    //   ],
      body: Container(   color: Theme.of(context).backgroundColor,child: _body()));
   // );
  }
}
