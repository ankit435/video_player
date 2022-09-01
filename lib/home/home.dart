import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:video/folder/directory.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/files.dart';
import 'package:video/helper/storage.dart';
import 'package:video/video_player/video_utilites/bottom_icon_buttons.dart';
import '../folder/showfile.dart';
import '../properties/bottomsheet_playlist.dart';
import '../properties/folder_bottom_sheet.dart';
import '../properties/setting.dart';
import '../queue/queue_list_screen.dart';
import '../search/search.dart';
import '../showdialogbox/file_delete.dart';
import '../video_player/video_play.dart';

class FlutterDemo extends StatefulWidget {
  const FlutterDemo({super.key});

  @override
  State<FlutterDemo> createState() => _FlutterDemoState();
}

class _FlutterDemoState extends State<FlutterDemo> with WidgetsBindingObserver {
  var _isInit = true;
  var _isLoading = false;
  bool detect = false;
  bool selection = false;
  int selcted_size = 0;
  var queue;

  Set<int> selction_list = {};
  void toggleselction() {
    print("hi");
    setState(() {
      selection = !selection;
      selction_list.clear();
    });
  }

  void toggleselctionlist(int value, int size) {
    setState(() {
      if (selction_list.contains(value)) {
        selction_list.remove(value);
        selcted_size -= size;
      } else {
        selction_list.add(value);
        selcted_size += size;
      }
    });
  }

  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addObserver(this);
    _fetching_data();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Widget _Popups() {
    return selection == false
        ? PopupMenuButton(
            itemBuilder: (context) => const [
              PopupMenuItem(
                  value: 1,
                  child: ListTile(
                    leading: Icon(Icons.select_all_outlined),
                    title: Text("Select"),
                  )),
              PopupMenuItem(
                  child: ListTile(
                leading: Icon(Icons.equalizer),
                title: Text("Equalizer"),
              )),
              PopupMenuItem(
                value: 2,
                child: ListTile(
                  leading: Icon(Icons.refresh),
                  title: Text("Refresh"),
                ),
              ),
              PopupMenuItem(
                  value: 3,
                  // onTap:   Navigator.of(context).pushNamed(Setting.routeName)
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Setting"),
                  )),
              PopupMenuItem(
                  value: 4,
                  child: ListTile(
                    leading: Icon(Icons.ads_click_outlined),
                    title: Text("ads"),
                  ))
            ],
            // offset: Offset(0, 100),
            // color: Colors.grey,
            elevation: 2,
            // on selected we show the dialog box
            onSelected: (value) {
              if (value == 1) {
                toggleselction();
              } else if (value == 2) {
                _isInit = true;
                _fetching_data();
              } else if (value == 3) {
                Navigator.of(context).pushNamed(Setting.routeName);
              } else if (value == 4) {
                getAllvideos();
                print("ads");
              }
            },
          )
        : PopupMenuButton(
            itemBuilder: (context) => const [
              PopupMenuItem(
                  value: 1,
                  // onTap:   Navigator.of(context).pushNamed(Setting.routeName)
                  child: ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("Hide Folder"),
                  )),
              PopupMenuItem(
                  value: 2,
                  child: ListTile(
                    leading: Icon(Icons.playlist_add),
                    title: Text("Add to playlist"),
                  )),
              PopupMenuItem(
                  value: 3,
                  child: ListTile(
                    leading: Icon(Icons.share),
                    title: Text("Share"),
                  ))
            ],

            elevation: 2,
            // on selected we show the dialog box
            onSelected: (value) async {
              if (value == 1) {
              } else if (value == 2) {
                _bottoplaylist(
                    context,
                    Provider.of<folder_details>(context, listen: false)
                        .selection_foldervideo(selction_list));
                setState(() {
                  selction_list.clear();
                  selection = false;
                });
              } else if (value == 3) {
                await Share.shareFiles(
                    Provider.of<folder_details>(context, listen: false)
                        .get_folder_path(selction_list));
                setState(() {
                  selction_list.clear();
                  selection = false;
                });
              }
            },
          );
  }

  List<Widget> _action() {
    return (selection == false
        ? [
            IconButton(
              onPressed: () {
                print("search click");
                Navigator.of(context).pushNamed(Search.routeName);
              },
              icon: Icon(Icons.search),
            ),
            IconButton(
              onPressed: (() {
                print("file click");
              }),
              icon: Icon(Icons.lock_rounded),
            ),
            _Popups(),
          ]
        : [
            IconButton(
              onPressed: (() {
                print("file click");
              }),
              icon: Icon(Icons.lock_rounded),
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
                            "Are you sure you want to delete ${selction_list.length} Folder?",
                      );
                    });
              },
              icon: const Icon(Icons.delete),
            ),
            _Popups()
          ]);
  }

  AppBar _Appbar(String title) {
    return AppBar(
        backgroundColor: Theme.of(context).primaryColor,
      
        leading: selection
            ? IconButton(
                icon: Icon(Icons.close), onPressed: () => toggleselction())
            : null,
        title: Text(title),
        actions: _action());
  }

  void getAllvideos() {
    var video =
        Provider.of<folder_details>(context, listen: false).getAllvideo();
    setState(() {
      //file_detail=video;
    });
  }

  Future<void> ondelete() async {
    toggleselction();
    if (selction_list.isNotEmpty) {
      await Provider.of<folder_details>(context, listen: false)
          .deleteFolder(selction_list);
    }
    selction_list.clear();
  }

// ignore: non_constant_identifier_names
  Future<void> _fetching_data() async {
    //print(_isInit);
    if (_isInit) {
      print("reloading");
      setState(() {
        _isLoading = true;
      });
      try {
        await Future.delayed(const Duration(milliseconds: 500));
        await Provider.of<folder_details>(context, listen: false)
            .addfolder(await Storage().localPath())
            .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      } catch (error) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Check storage permission !.'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('okay'),
              )
            ],
          ),
        );
      }
    }
    _isInit = false;
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;
    if (state == AppLifecycleState.paused && !detect) {
      setState(() {
        detect = true;
      });
    } else if (state == AppLifecycleState.resumed) {
      setState(() {
        detect = false;
        _isInit = true;
        _fetching_data();
      });
      // widget.onPressed;
    }
  }

  Future<void> _pullRefresh() async {
    _isInit = true;
    _fetching_data();
    return Future.delayed(Duration(seconds: 1));
  }

  void didChangeDependencies() {
    _fetching_data();
    super.didChangeDependencies();
  }

  void _videoproprties(BuildContext context, int f_Id) {
    // print(f_Id);
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
          child: Floder_bottomsheet(
              bottoplaylist: _bottoplaylist, f_Id: f_Id, v_id: -1),
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
      backgroundColor: Theme.of(context).backgroundColor,
      context: context,
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

  void _bottoplaylist(BuildContext context, List<video> f_videos) {
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
          // folder directory plylist and pass folder video

          child: BottomPlayList(
              v_index: -1, f_index: -1, condition: false, passvideo: f_videos),
        );
      },
    );
  }

  var folder_list;
  Widget build(BuildContext context) {
    //print(file)
    folder_list = Provider.of<folder_details>(context, listen: true).items();
    queue = Provider.of<queue_playerss>(context, listen: true).getqueuevideo();

    return Scaffold(
    
      appBar: _Appbar(selction_list.length <= 0
          ? "Video"
          : selction_list.length.toString() + " Selected"),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: _isLoading
            ? Container(
                child: Center(
                child: CircularProgressIndicator(),
              ))
            : Center(
                child: folder_list.isNotEmpty
                    ? RefreshIndicator(onRefresh: _pullRefresh, child: _body())
                    : ElevatedButton(
                        onPressed: () {
                          _isInit = true;
                          _fetching_data();
                        },
                        child: Text("Reload")),
              ),
      ),
    );
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
                Icon(icon, color:IconTheme.of(context).color,), // icon
                // text
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: folder_list.length,
            itemBuilder: (context, index) {
              return CharacteristListItem(
                bottomsheet: _videoproprties,
                folder_detail: folder_list[index],
                toggleselction: toggleselction,
                selection: selection,
                selction_list: selction_list,
                toggleselctionlist: toggleselctionlist,
                //queue_list_video:queue_list_video
              );
            },
          ),
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
                        Icon(Icons.disc_full),
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
              color:  Theme.of(context).textTheme.bodyText1!.color,
           ),
                        )
                        ,
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
                          print(Provider.of<queue_playerss>(context,
                                  listen: false)
                              .getskipnextvideo());

                          // print(queue[0]);
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
    );
  }
}
