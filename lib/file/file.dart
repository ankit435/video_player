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

import 'grid_view.dart';

class Files extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String f_id;
  final String title;
  final bool recent;

  // ignore: non_constant_identifier_names
  const Files({Key? key,required this.f_id,required this.title,required this.recent}) : super(key: key);
  static const routeName = '/file_video';
  @override
  State<Files> createState() => _FilesState();
}

class _FilesState extends State<Files> {
  @override
  bool selection = false;
  Map<String, String> selction_list = {};
  int icons_value = 0;
  late List<video> File_path;
  
  // late String title;
  // var f_id;
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
  Widget text(String text) {
    return Text(text,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyText1!.color,
        ));
  }

  void _videoproprties(BuildContext context, String vId, String fId) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      backgroundColor: Theme.of(context).backgroundColor,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {},
          behavior: HitTestBehavior.opaque,
          child: Bottom_model(
              onsinglefiledelete: onsinglefiledelete,
              v_id: vId,
              file_detail: File_path,
              f_id: fId,
              onPressed: _bottoplaylist),
        );
      },
    );
  }

  void _bottoplaylist(BuildContext context, String vId, String fId) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
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
              v_id: vId, passvideo: [], f_id: fId, condition: true),
        );
      },
    );
  }

  void queue_list_video(BuildContext context) {
    // print(f_Id);
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
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
          .getfoldertotalvideo(widget.f_id, sort, sortrevrsed);
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

  void toggleselctionlist(String value, int size, String pId) {
    setState(() {
      if (selction_list.containsKey(value)) {
        selction_list.remove(value);
        selcted_size -= size;
      } else {
        selction_list.addAll({value: pId});
        selcted_size += size;
      }
    });
  }

  void remove_playlist(Map<String, Set<String>> removeList) {
    removeList.forEach((key, value) {
      value.forEach((element) {
        Provider.of<PlayList_detail>(context, listen: false)
            .remove_from_playlist({key: element});
      });
    });
  }

  Future<void> ondelete() async {
    if (selction_list.isNotEmpty) {

      if(widget.recent){
        Provider.of<recent_videos>(context, listen: false).remove_from_recent(selction_list.keys.toList());
      }
      else{
        Map<String, Set<String>> removeList =
          await Provider.of<folder_details>(context, listen: false)
              .delete_file(selction_list);
        remove_playlist(removeList);

      }


    }
    toggleselction();
    selction_list.clear();
  }

  Future<void> onsinglefiledelete(Map<String, String> singleVideoList) async {

    if (singleVideoList.isNotEmpty) {

       if(widget.recent){
        Provider.of<recent_videos>(context, listen: false).remove_from_recent(singleVideoList.keys.toList());
      }
      else{

      Map<String, Set<String>> removeList =
          await Provider.of<folder_details>(context, listen: false)
              .delete_file(singleVideoList);
      remove_playlist(removeList);
    }
    }
  }

  void _select_all_file(List<video> filePath, int size) {
    setState(() {
      if (filePath.length == selction_list.length) {
        selction_list.clear();
        selcted_size = 0;
      } else {
        selction_list.clear();
        filePath.forEach((element) {
          selction_list.addAll({element.v_id: element.parent_folder_id});
        });
        selcted_size = size;
      }
    });
  }

  Widget _Popups() {
    return PopupMenuButton(
      color: Theme.of(context).backgroundColor,
      icon: icons(Icons.more_vert),
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
                      return Show_dialog(
                          onPressedtext: "Delete",
                          onPressed: ondelete,
                          title: "Delete Video from Device",
                          text:
                              "Are you sure you want to delete ${selction_list.length} File?");
                    });
              },
              //ondelete,
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
      leading: new IconButton(
        icon: icons(selection ? Icons.close : Icons.arrow_back),
        onPressed: () =>
            selection ? toggleselction() : Navigator.of(context).pop(),
      ),
      title: text(title),
      actions: action(),
    );
  }

  Widget _listViewbulder(List<video> FilePath) {
    return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: FilePath.length,
        itemBuilder: (context, index) {
          return Files_path(
            file_path: FilePath,
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

  Widget _gridviewbuilder(List<video> FilePath) {
    print(MediaQuery.of(context).size.width);
    return GridView.builder(
      itemCount: FilePath.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (MediaQuery.of(context).size.width / 125.0).toInt(),
        //childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height/2.5),
        childAspectRatio: 1 / 1.2,
      ),
      itemBuilder: (context, index) {
        return GridTile(
            child: Grid_view_file(
          file_path: FilePath,
          index: index,
          value: icons_value,
          onPressed: toggleselction,
          selection: selection,
          selction_list: selction_list,
          onPressed1: toggleselctionlist,
          bottommodel: _videoproprties,
        ));

        // Container(
        //     color: Colors.red,
        //     child: Center(child: text(File_path[index].v_title)))
      },
    );
  }

  Widget icons(IconData icon) {
    return Icon(
      icon,
      color: Theme.of(context).iconTheme.color,
    );
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
                Icon(
                  icon,
                  color: IconTheme.of(context).color,
                ),
                // text
              ],
            ),
          ),
        ),
      ),
    );
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

  Widget top_video_detail(size) {
    return Container(
      child: ListTile(
          title: Text(
            '${File_path.length} video  ${Storage().getFileSize(size, 1)}',
            style:
                TextStyle(fontSize: 13, color: Theme.of(context).primaryColor),
          ),
          trailing: selection
              ? Checkbox(
                checkColor: Theme.of(context).textTheme.bodyText1!.color,
     fillColor: MaterialStateProperty.resolveWith(getColor),

                  value: File_path.length == selction_list.length,
                  onChanged: (value) {
                    _select_all_file(File_path, size);
                  })
              : null),
    );
  }

  Widget content_view() {
    return Flexible(
      child: icons_value == 0 || icons_value == 1
          ? _listViewbulder(File_path)
          : _gridviewbuilder(File_path),
    );
  }

  Widget _body({int size = 0}) {
    return Column(
      children: [
        top_video_detail(size),
        content_view(),
        bottom_play_bar(),
      ],
    );
  }

  Widget bottom_play_bar() {
    return queue[0] && queue[3].length > 0
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
                    iconbutton(Icons.disc_full, () {
                      Navigator.of(context).pushNamed(Play_video.routeName);
                    })
                  ],
                ),
                title: AutoSizeText(
                  Provider.of<queue_playerss>(context, listen: false)
                      .video_title(),
                  maxLines: 2,
                  minFontSize: 13,
                  maxFontSize: 18,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
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
                    iconbutton(Icons.skip_next, () {}),
                    iconbutton(Icons.menu, () {
                      queue_list_video(context);
                    })
                  ],
                ),
              ),
            ),
          )
        : Container();
  }

  Widget build(BuildContext context) {
    File_path =widget.recent?Provider.of<recent_videos>(context, listen: true).getrecent_video_list() : Provider.of<folder_details>(context, listen: true)
        .getfoldertotalvideo(widget.f_id, sort, sortrevrsed);
    int size =widget.recent?Provider.of<recent_videos>(context, listen: true).getRecentvideo_size()
       : Provider.of<folder_details>(context, listen: true).gefoldersize(widget.f_id);
    queue = Provider.of<queue_playerss>(context, listen: true).getqueuevideo();

    String selectedTitle = selction_list.length.toString() + " " + 'selected';
    return Scaffold(
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              // pinned: true,
              leading:  IconButton(
                icon: icons(selection ? Icons.close : Icons.arrow_back),
                onPressed: () =>
                    selection ? toggleselction() : Navigator.of(context).pop(),
              ),
              floating: true,
              snap: true,
              title: text(selection ? selectedTitle : widget.title),
              actions: action(),
            ),
          ],
          body: Container(
              color: Theme.of(context).backgroundColor, child: _body(size: size )),
        ),
      ),
    );
  }
}
