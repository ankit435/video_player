import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:video/folder/directory.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/files.dart';
import 'package:video/helper/storage.dart';
import '../folder/showfile.dart';
import '../properties/bottomsheet_playlist.dart';
import '../properties/folder_bottom_sheet.dart';
import '../properties/setting.dart';
import '../queue/queue_list_screen.dart';
import '../search/search.dart';

class FlutterDemo extends StatefulWidget {

  const FlutterDemo({super.key});

  @override
  State<FlutterDemo> createState() => _FlutterDemoState();
}


class _FlutterDemoState extends State<FlutterDemo> with WidgetsBindingObserver  {
 
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
    });
  }
  void toggleselctionlist(int value, int size) {
    setState(() {
      if(selction_list.contains(value)) {
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
    return PopupMenuButton(
      itemBuilder: (context) => const[
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
          _isInit=true;
          _fetching_data();
        } else if (value == 3) {
          Navigator.of(context).pushNamed(Setting.routeName);
        } else if (value == 4) {
           getAllvideos();
          print("ads");
        }
      },
    );
  }
  List<Widget> _action(){
  return ([
      IconButton(
        onPressed: () {
          print("search click");
          Navigator.of(context).pushNamed(Search.routeName);
        },
        icon: const Icon(Icons.search),
      ),
      IconButton(
        onPressed: (() {
          print("file click");
        }),
        icon: Icon(Icons.lock_rounded),
      ),
      _Popups(),
    ]);

  }
  
  AppBar _Appbar(String title) {
    return AppBar(title: Text(title), actions: _action());
  }
  
  void getAllvideos()  {
    var video=Provider.of<folder_details>(context, listen: false).getAllvideo();
    setState(() {
      //file_detail=video;
    });

  }

// ignore: non_constant_identifier_names
   Future<void>  _fetching_data() async {
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
    _isInit=true;
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
  void _bottoplaylist(BuildContext context, List<video> f_videos) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
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
    folder_list=Provider.of<folder_details>(context, listen: true).items();
     queue=Provider.of<queue_playerss>(context, listen: true).getqueuevideo();

    return Scaffold(
      appBar: _Appbar("Video"),
      body: _isLoading?Container(child: Center(child: CircularProgressIndicator(),)): Center(
        child: folder_list.isNotEmpty? RefreshIndicator( onRefresh: _pullRefresh,child: _body()):ElevatedButton(onPressed: (){
          _isInit=true;
          _fetching_data();
        }, child: Text("Reload")),
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
                Icon(icon), // icon
                // text
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget _body(){
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
      queue[3].length>0?  Align(alignment: Alignment.bottomCenter, child: Container(  child:ListTile( tileColor: Colors.black, leading: Icon(Icons.disc_full),title: Text("Hello"),trailing: Row(mainAxisSize: MainAxisSize.min,children: <Widget>[
            iconbutton(Icons.play_arrow,(){}),iconbutton(Icons.skip_next,(){}),iconbutton(Icons.menu,(){queue_list_video(context);})
       ],),),),):Container()
      ],
    );
  }
}
