



import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Music/music.dart';
import '../Playlist/playlist_screen.dart';
import '../Videos/video.dart';
import '../helper/files.dart';
import '../home/home.dart';

class Bottomnavigation extends StatefulWidget {
  const Bottomnavigation({Key? key}) : super(key: key);

  @override
  State<Bottomnavigation> createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottomnavigation> {
  @override
 int _selectedIndex = 0;

 final _widgetOptions1 = [
        FlutterDemo(),
        Video_Home(),
        Music(),
        Playlist_Screen(),
      ];
 final _widgetOptions2 = [
        FlutterDemo(),
        Video_Home(),
        Playlist_Screen(),
      ];

Widget icons(IconData icon,int selceted){
  return Icon(icon,color: selceted== _selectedIndex?Theme.of(context).iconTheme.color:Theme.of(context).secondaryHeaderColor,);
}

List<BottomNavigationBarItem> bottobar(){
  return Provider.of<Setting_data>(context,listen: true).get_setting_show_music()? [
        BottomNavigationBarItem(
          icon: icons(Icons.home,0),
          label: 'Home',
          backgroundColor: Theme.of(context).primaryColor,
          
        ),
        BottomNavigationBarItem(
          icon: icons(Icons.video_library,1),
          label: 'Video',
           backgroundColor: Theme.of(context).primaryColor,
        ),
        BottomNavigationBarItem(
          icon: icons(Icons.my_library_music_outlined,2),
          label: 'Muisc',
           backgroundColor: Theme.of(context).primaryColor,
        ),
        BottomNavigationBarItem(
          icon: icons(Icons.playlist_play_sharp,3),
          label: 'Playlist',
           backgroundColor: Theme.of(context).primaryColor,
          
        ),
      ]:
      [
 BottomNavigationBarItem(
          icon: icons(Icons.home,0),
          label: 'Home',
          backgroundColor: Theme.of(context).primaryColor,
          
        ),
        BottomNavigationBarItem(
          icon: icons(Icons.video_library,1),
          label: 'Video',
           backgroundColor: Theme.of(context).primaryColor,
        ),
        BottomNavigationBarItem(
          icon: icons(Icons.playlist_play_sharp,2),
          label: 'Playlist',
           backgroundColor: Theme.of(context).primaryColor,
          
        ),

      ];
}

   Widget _bottomNavigation() {
    return BottomNavigationBar(
      items:  bottobar(),
      //type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      backgroundColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).secondaryHeaderColor,
      selectedFontSize:
          Theme.of(context).textTheme.titleLarge!.fontSize!.toDouble(),
      unselectedFontSize:
          Theme.of(context).textTheme.titleSmall!.fontSize!.toDouble(),
      selectedItemColor: Theme.of(context).primaryIconTheme.color,
      onTap: _onItemTapped,
    );
  }
 void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    // Provider.of<recent_videos>(context, listen: false).fetchrecent_video();
    // Provider.of<Setting_data>(context, listen: false).set_setting_data();
     setState(() {
    });
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      //body: IndexedStack(children:_widgetOptions,index: _selectedIndex,) ,
      body:Provider.of<Setting_data>(context,listen: true).get_setting_show_music()? _widgetOptions1[_selectedIndex]:_widgetOptions2[_selectedIndex],
      bottomNavigationBar:   _bottomNavigation(),
    );

  }
}