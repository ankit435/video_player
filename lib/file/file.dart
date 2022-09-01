import 'package:auto_size_text/auto_size_text.dart';
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
import '../video_player/video_play.dart';
import 'package:share_plus/share_plus.dart';

class Files extends StatefulWidget {
   Files({Key? key}) : super(key: key);
  static const  routeName = '/file_video';
  @override
  State<Files> createState() => _FilesState();
}

class _FilesState extends State<Files> {
  @override
  bool selection = false;
  Map<int, int> selction_list = {};
  int icons_value = 0;
  late List<video> File_path;
  late String title;
  var f_id;
  var queue;

  int selcted_size = 0;
  String sort = "Name";
  final Map<String, bool>? sort_cond = {
    "Name": false,
    "Date": false,
    "Size": false,
    "Length": false
  };
  bool sortrevrsed = false;
Widget text(String text){
  return Text(text , style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
           ));
}
  void _videoproprties(BuildContext context, int id, int f_id) {
    showModalBottomSheet(
      shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
     backgroundColor: Theme.of(context).backgroundColor,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: Bottom_model(
              v_id: id,
              file_detail: File_path,
              f_id: f_id,
              onPressed: _bottoplaylist),
        );
      },
    );
  }

  void _bottoplaylist(BuildContext context, int v_index, int f_index) {
    showModalBottomSheet(
      shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      backgroundColor: Theme.of(context).backgroundColor,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          //contdition to be ture for one video
          child: BottomPlayList(
              v_index: v_index,
              passvideo:  [],
              f_index: f_index,
              condition: true),
        );
      },
    );
  }

  void queue_list_video(BuildContext context) {
    // print(f_Id);
    showModalBottomSheet(
      shape:  RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: false,
      context: context,
       backgroundColor: Theme.of(context).backgroundColor,
      builder: (context) {
        return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: queue_list(
              queue_list_video: queue[3],
            ));
      },
    );
  }

  void sorting(String sorts, bool reverse) {
    setState(() {
      sortrevrsed = reverse;
      sort = sorts;
      File_path = Provider.of<folder_details>(context, listen: false)
          .getfoldertotalvideo(f_id, sort, sortrevrsed);
    });
  }

  void toggleselction() {
    setState(() {
      selection = !selection;
      selction_list.clear();
    });
  }

// void Create_playlists(){

// }

  void toggleselctionlist(int value, int size, int p_id) {
    setState(() {
      if (selction_list.containsKey(value)) {
        selction_list.remove(value);
        selcted_size -= size;
      } else {
        selction_list.addAll({value: p_id});
        selcted_size += size;
      }
    });
  }

  Future<void> ondelete() async {
    toggleselction();
    if (selction_list.isNotEmpty) {
      await Provider.of<folder_details>(context, listen: false)
          .delete_file(selction_list);
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
        file_path.forEach((element) {
          selction_list.addAll({element.v_id: element.parent_folder_id});
        });
        selcted_size = size;
      }
    });
  }

  Widget _Popups() {
    return PopupMenuButton(
      itemBuilder: (context) => selection
          ? [
               PopupMenuItem(
                  value: 1,
                  child: ListTile(
                    leading: icons(Icons.favorite),
                    title: text("Add to fav"),
                  )),
               PopupMenuItem(
                  value: 2,
                  child: ListTile(
                    leading: icons(Icons.share),
                    title: text("share"),
                  )),
               PopupMenuItem(
                  value: 3,
                  child: ListTile(
                    leading: icons(Icons.details),
                    title: text("properties"),
                  )),
            ]
          : [
               PopupMenuItem(
                  value: 4,
                  child: ListTile(
                    leading: icons(Icons.select_all),
                    title: text("Select"),
                  )),
               PopupMenuItem(
                  value: 5,
                  child: ListTile(
                    leading: icons(Icons.sort),
                    title: text("sort by"),
                  )),
            ],
      elevation: 2,
      // on selected we show the dialog box
      onSelected: (value) async {
        if (value == 1) {
        } else if (value == 2) {
          await Share.shareFiles(
              Provider.of<folder_details>(context, listen: false)
                  .getallvideo_path(selction_list));
          setState(() {
            selction_list.clear();
            selection = false;
          });
        } else if (value == 3) {
        } else if (value == 4) {
          toggleselction();
        } else if (value == 5) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return short_property(
                sorting: sorting,
                sort_by: sort,
                sort_cond: sort_cond,
              );
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
              icon: icons(Icons.lock_rounded),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Show_dialog(onPressedtext:"Delete",onPressed:ondelete,title: "Delete Video from Device",text:"Are you sure you want to delete ${selction_list.length} File?");
                    });
              },
              //ondelete,
              icon: icons(Icons.delete),
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
                icon: icons(icons_value == 0
                    ? Icons.list
                    : icons_value == 1
                        ? Icons.list_alt_rounded
                        : Icons.grid_view_outlined)),
            _Popups(),
          ]);
  }

  AppBar _Appbar(String title) {
    return AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      
      leading: new IconButton(
        icon: icons(selection ? Icons.close : Icons.arrow_back),
        onPressed: () =>
            selection ? toggleselction() : Navigator.of(context).pop(),
      ),
      title: text(title),
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
            bottommodel: _videoproprties,
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
                child: Center(child: text(File_path[index].v_title))));
      },
    );
  }
  Widget icons(IconData icon){
  return Icon(icon,color:Theme.of(context).secondaryHeaderColor,);
}

  @override
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
               // icon
                Icon(icon, color:IconTheme.of(context).color,), 
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
    f_id = arg['v2'];
    File_path = Provider.of<folder_details>(context, listen: true)
        .getfoldertotalvideo(f_id, sort, sortrevrsed);
    int size =
        Provider.of<folder_details>(context, listen: true).gefoldersize(f_id);
    queue = Provider.of<queue_playerss>(context, listen: true).getqueuevideo();

    String selected_title = selction_list.length.toString() + " " + 'selected';
    return Scaffold(
      
      appBar: _Appbar(selection ? selected_title : title),
      body: Container(
           color: Theme.of(context).backgroundColor,
        child: Column(
          children: [
            Container(
              height: 50,
              child: ListTile(
                  title: Text(
                    '${File_path.length} video  ${Storage().getFileSize(size, 1)}',
                    style: TextStyle(fontSize: 13, 
              color:  Theme.of(context).primaryColor
           ),
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
            queue[0] && queue[3].length > 0
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      child: ListTile(
                        onTap: () {
                          Navigator.of(context).pushNamed(Play_video.routeName);
                        },
                        tileColor: Colors.black,
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            iconbutton(Icons.close, () {
                              Provider.of<queue_playerss>(context, listen: false)
                                  .togle_bacground_play();
                            }),
                           iconbutton(Icons.disc_full, (){})
                          ],
                        ),
                        title: AutoSizeText(
                            Provider.of<queue_playerss>(context, listen: false)
                                .video_title(),
                            maxLines: 2,
                            minFontSize: 13,
                            maxFontSize: 18,
                            overflow: TextOverflow.ellipsis, style: TextStyle(
              color:  Theme.of(context).textTheme.bodyText1!.color,
           ),),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            iconbutton(
                                queue[1].value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow, () {
                              Provider.of<queue_playerss>(context, listen: false)
                                  .updatecontoler_play_pause();
                            }),
                            iconbutton(Icons.skip_next, () {
                             
                            }),
                            iconbutton(Icons.menu, () {
                              queue_list_video(context);
                            })
                          ],
                        ),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
