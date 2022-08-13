
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/file/files_detail.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/files.dart';
import 'package:video/helper/storage.dart';
import '../properties/file_bootom_sheet.dart';
import '../properties/bottomsheet_playlist.dart';
import '../properties/sort_property.dart';
import '../queue/queue_list_screen.dart';
import '../showdialogbox/file_delete.dart';

class Files extends StatefulWidget {
  const Files({Key? key}) : super(key: key);
  static const routeName = '/file_video';
  @override
  State<Files> createState() => _FilesState();
}

class _FilesState extends State<Files> {
  @override
  bool selection = false;
  Map<int,int> selction_list = {};
  int icons_value = 0;
  late List<video> File_path;
  late String title ;
  var f_id;
  var queue;
  
  int selcted_size = 0;
  String sort="Name";
   final Map<String,bool>? sort_cond= {"Name":false,"Date":false,"Size":false,"Length":false};
  bool sortrevrsed=false;



void _videoproprties(BuildContext context, int id,int f_id) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,

          child:Bottom_model(v_id:id,file_detail: File_path,f_id:f_id,onPressed:_bottoplaylist),
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
          //contdition to be ture for one video
          child:BottomPlayList(v_index:v_index,passvideo: const [],f_index: f_index,condition: true),
        );
      },
    );
  }


void queue_list_video(BuildContext context) {
    // print(f_Id);
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: false,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: queue_list(queue_list_video: queue[3],)
        );
      },
    );
  }

  void sorting(String sorts,bool reverse){
    setState(() {
      sortrevrsed=reverse;
      sort=sorts;
      File_path = Provider.of<folder_details>(context, listen: false).getfoldertotalvideo(f_id,sort,sortrevrsed);
    });
  }
  void toggleselction() {
    setState(() {
      selection = !selection;
    });
  }

// void Create_playlists(){

// }

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
                  value: 1,
                    child: ListTile(
                  leading: Icon(Icons.favorite),
                  title: Text("Add to fav"),
                )),
                const PopupMenuItem(
                  value: 2,
                    child: ListTile(
                  leading: Icon(Icons.share),
                  title: Text("share"),
                )),
              const PopupMenuItem(
                value: 3,
                    child: ListTile(
                  leading: Icon(Icons.details),
                  title: Text("properties"),
                )
                ),
              ]
            : [
               const PopupMenuItem(
                     value:4,
                    child: ListTile(
                      leading: Icon(Icons.select_all),
                      title: Text("Select"),
                    )),
                 const PopupMenuItem(
                  value:5,
                  child: ListTile(
                  leading: Icon(Icons.sort),
                  title: Text("sort by"),
                )),
              ],
        elevation: 2,
      // on selected we show the dialog box
      onSelected: (value) {
        if (value == 1) {
         
        } else if (value == 2) {
          
        } else if (value == 3) {
         
        } else if (value == 4) {
         toggleselction();
        }
         else if (value == 5) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return short_property(sorting:sorting, sort_by: sort, sort_cond: sort_cond,);
              },
            );
        }
      },
              
              
              );
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
              onPressed: (){
                    showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Delete_file_dialog(ondelete:ondelete);
                    });
              },
              //ondelete,
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
      leading: new IconButton(
        icon: new Icon(selection?Icons.close: Icons.arrow_back),
        onPressed: () =>selection? toggleselction(): Navigator.of(context).pop(),
      ),
      title: Text(title),
      actions: action(),
    );
  }

  Widget _listViewbulder(List<video> File_path) {
    return ListView.builder(
        itemCount: File_path.length,
        itemBuilder: (context, index) {
          return Files_path(
            file_path: File_path,
            index: index,
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
    return GridView.builder(
        itemCount: File_path.length,
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          return GridTile(
              child: Container(
                  color: Colors.red,
                  child: Center(child: Text(File_path[index].v_title))));
        },);
  }


    Widget iconbutton(IconData icon, Function param1) {
    return SizedBox.fromSize(
      size: Size(56, 56), // button width and height
      child: ClipOval(
        child: Material(
          color: Colors.transparent, // button color
          child: InkWell(
            splashColor: Colors.green, // splash color
            onTap: () {
              param1();
            }, // button pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon), // icon
                // text
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;
    title = arg['v1'];
    f_id=arg['v2'];
    File_path = Provider.of<folder_details>(context, listen: true).getfoldertotalvideo(f_id,sort,sortrevrsed);
    int size=Provider.of<folder_details>(context, listen: true).gefoldersize(f_id);
     queue=Provider.of<queue_playerss>(context, listen: true).getqueuevideo();
   print(queue[3].length);
    String selected_title = selction_list.length.toString() + " " + 'selected';
    return Scaffold(
      appBar: _Appbar(selection ? selected_title : title),
      body: Column(
        children: [
          Container(
            height: 50,
            child: ListTile(
                title: Text(
                  '${File_path.length} video  ${Storage().getFileSize(size, 1)}',
                  style: TextStyle(fontSize: 13),
                ),
                trailing: selection
                    ? Checkbox(
                        value: File_path.length == selction_list.length,
                        onChanged: (value) {
                          _select_all_file(File_path, size);
                        })
                    : null),
          ),
          Flexible(
            child: icons_value == 0 || icons_value == 1
                ? _listViewbulder(File_path)
                : _gridviewbuilder(File_path),
          ),
        
        queue[3].length>0?  Align(alignment: Alignment.bottomCenter, child: Container(  child:ListTile( tileColor: Colors.black, leading: Icon(Icons.disc_full),title: Text("Hello"),trailing: Row(mainAxisSize: MainAxisSize.min,children: <Widget>[
            iconbutton(Icons.play_arrow,(){}),iconbutton(Icons.skip_next,(){}),iconbutton(Icons.menu,(){queue_list_video(context);})
       ],),),),):Container()
        ],

      ),
    );
  }
}
