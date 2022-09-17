import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:video/folder/directory.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/files.dart';
import 'package:video/helper/storage.dart';
import 'package:video/video_player/video_utilites/bottom_icon_buttons.dart';
import '../file/file.dart';
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
  static const routeName = '/home';
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
  bool mounted = true;

  Set<String> selction_list = {};
  void toggleselction() {
    setState(() {
      selection = !selection;
      selction_list.clear();
    });
  }

  void toggleselctionlist(String value, int size) {
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

  late AnimationController _animationController;
  bool isPlaying = false;

  void initState() {
    WidgetsBinding.instance.addObserver(this);
   //_fetching_data();
    Provider.of<recent_videos>(context, listen: false).fetchrecent_video();
    super.initState();
  }


  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    mounted = false;
    super.dispose();
  }

  Widget text(String text) {
    return Text(text,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyText1!.color,
        ));
  }

  Widget _Popups() {
    return selection == false
        ? PopupMenuButton(
            color: Theme.of(context).backgroundColor,
            icon: icons(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 1,
                  child: ListTile(
                    leading: icons(Icons.select_all),
                    title: text("Select"),
                  )),
              PopupMenuItem(
                  child: ListTile(
                leading: icons(Icons.equalizer),
                title: text("Equalizer"),
              )),
              PopupMenuItem(
                value: 2,
                child: ListTile(
                  leading: icons(Icons.refresh),
                  title: text("Refresh"),
                ),
              ),
              PopupMenuItem(
                  value: 3,
                  // onTap:   Navigator.of(context).pushNamed(Setting.routeName)
                  child: ListTile(
                    leading: icons(Icons.settings),
                    title: text("Setting"),
                  )),
              PopupMenuItem(
                  value: 4,
                  child: ListTile(
                    leading: icons(Icons.ads_click_outlined),
                    title: text("ads"),
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
                getloaddata();
              } else if (value == 3) {
                Navigator.of(context).pushNamed(Setting.routeName);
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => Setting(isLoading: _isLoading,

                //         )));
              } else if (value == 4) {
                getAllvideos();
                print("ads");
              }
            },
          )
        : PopupMenuButton(
            color: Theme.of(context).backgroundColor,
            icon: icons(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 1,
                  // onTap:   Navigator.of(context).pushNamed(Setting.routeName)
                  child: ListTile(
                    leading: icons(Icons.settings),
                    title: text("Hide Folder"),
                  )),
              PopupMenuItem(
                  value: 2,
                  child: ListTile(
                    leading: icons(Icons.playlist_add),
                    title: text("Add to playlist"),
                  )),
              PopupMenuItem(
                  value: 3,
                  child: ListTile(
                    leading: icons(Icons.share),
                    title: text("Share"),
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
              icon: icons(Icons.search),
            ),
            IconButton(
              onPressed: (() {
                print("file click");
              }),
              icon: icons(Icons.lock_rounded),
            ),
            _Popups(),
            Padding(padding: EdgeInsets.only(left: 15)),
          ]
        : [
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
                            "Are you sure you want to delete ${selction_list.length} Folder?",
                      );
                    });
              },
              icon: icons(Icons.delete),
            ),
            _Popups(),
            Padding(padding: EdgeInsets.only(left: 15)),
          ]);
  }

  Widget icons(IconData icon) {
    return Icon(
      icon,
      color: Theme.of(context).iconTheme.color,
    );
  }

  AppBar _Appbar(String title) {
    return AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).backgroundColor,
        leading: selection
            ? IconButton(
                icon: icons(Icons.close), onPressed: () => toggleselction())
            : null,
        title: Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: text(title),
        ),
        actions: _action());
  }

  void getAllvideos() {
    var video =
        Provider.of<folder_details>(context, listen: false).getAllvideo();
    setState(() {
      //file_detail=video;
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

  Future<void> onsinglefolderdelete(Set<String> delete) async {
    if (delete.isNotEmpty) {
      remove_playlist(await Provider.of<folder_details>(context, listen: false)
          .deleteFolder(delete));
    }
  }

  Future<void> ondelete() async {
    if (selction_list.isNotEmpty) {
      remove_playlist(await Provider.of<folder_details>(context, listen: false)
          .deleteFolder(selction_list));
    }
    toggleselction();
    selction_list.clear();
  }

  Future<void> _fetching_data() async {
    if (mounted) {
      var pref = await SharedPreferences.getInstance();

      bool? initData = pref.getBool("init_data");
      //print(_isInit);
      if (initData != null && initData) {
        setState(() {
          // pref.setBool('is_loading', true).then((value) => _isLoading=true);
          _isLoading = true;
        });
        try {
          //await Future.delayed(const Duration(milliseconds: 500));
          await Provider.of<folder_details>(context, listen: false)
              .fetchdatabase()  
              .then((_) {
            setState(() {
              _isLoading = false;
            });
          });
        } catch (error) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: text('An error occurred!'),
              content: text('Check storage permission !.'),
              actions: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: text('okay'),
                )
              ],
            ),
          );
        }
      }
      await pref.setBool('init_data', false);
    }
    //_isInit = false;
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      //_isInit = true;

      return;
    }

    if (state == AppLifecycleState.paused && !detect) {
      setState(() {
        detect = true;
      });
    } else if (state == AppLifecycleState.resumed) {
      setState(() {
        detect = false;
        getloaddata();
      });
      // widget.onPressed;
    }
  }

  Future<void> _pullRefresh() async {
    getloaddata();
    return Future.delayed(Duration(seconds: 1));
  }

  void didChangeDependencies() {
    _fetching_data();
    // print("dependency");
    super.didChangeDependencies();
  }

  void _videoproprties(BuildContext context, String f_Id) {
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
              onsinglefolderdelete: onsinglefolderdelete,
              bottoplaylist: _bottoplaylist,
              f_Id: f_Id,
              v_id: " -1"),
        );
      },
    );
  }

  Future<void> getloaddata() async {
    print("load data");
    var pref = await SharedPreferences.getInstance();
    await pref.setBool('init_data', true);
    _fetching_data();
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
              v_id: "-1", f_id: "-1", condition: false, passvideo: f_videos),
        );
      },
    );
  }

  Widget folder_contennt(Height) {
    return Container(
      height: Height -
          AppBar().preferredSize.height -
          MediaQuery.of(context).padding.top -
          MediaQuery.of(context).padding.bottom,
      width: double.infinity,
      child: _isLoading
          ? Center(child: CircularProgressIndicator())
          :_body()
          
          //  folder_list.isNotEmpty
          //     ? RefreshIndicator(onRefresh: _pullRefresh, child:)
          //     : ElevatedButton(
          //         onPressed: () {
          //           getloaddata();
          //         },
          //         child: text("Reload")),
    );
  }

  var folder_list;
  Widget build(BuildContext context) {
    folder_list = Provider.of<folder_details>(context, listen: true).items();
    queue = Provider.of<queue_playerss>(context, listen: true).getqueuevideo();

    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          

            color: Theme.of(context).backgroundColor,
            child: RefreshIndicator (
              onRefresh: _pullRefresh,
              child: Stack(
                children: [
                  Column(
                    children: [
                      
                      Container(
                        child: _Appbar(selction_list.length <= 0
                            ? "Video"
                            : selction_list.length.toString() + " Selected"),
                      ),
                      Provider.of<recent_videos>(context, listen: true).showReecent()? 

                      Container(
                        height: 50,
                        child: ListTile(
                          leading: Icon(
                            Icons.folder,
                            color: IconTheme.of(context).color,
                          ),
                          title: text("Recently Played"),
                          onTap: (){
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Files(
                          f_id: "",
                          title: "Recent Video",
                          recent: true,
                          )));
            
                          },
                        ),
                      ):Container(),
                      folder_contennt(constraints.maxHeight - 50),
                    ],
                  ),
                  bottom_background(),
                ],
              ),
            ));
      },
    ));
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
                Icon(
                  icon,
                  color: IconTheme.of(context).color,
                ), // icon
                // text
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottom_background() {
    return queue[0] && queue[3].length > 0
        ? Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              child: ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(Play_video.routeName);
                },
                tileColor: Theme.of(context).backgroundColor,
                leading: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    iconbutton(Icons.close, () {
                      Provider.of<queue_playerss>(context, listen: false)
                          .togle_bacground_play();
                    }),
                    iconbutton(Icons.disc_full, () {
                      Navigator.of(context).pushNamed(Play_video.routeName);
                    }),
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
                    iconbutton(Icons.skip_next, () {
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
        : Container();
  }

  Widget _body() {
    return ListView.builder(
      padding: EdgeInsets.zero,
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
    );
  }
}
