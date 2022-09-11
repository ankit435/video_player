



import 'package:flutter/material.dart';
import '../Music/music.dart';
import '../Playlist/playlist_screen.dart';
import '../Videos/video.dart';
import '../home/home.dart';

class Bottomnavigation extends StatefulWidget {
  const Bottomnavigation({Key? key}) : super(key: key);

  @override
  State<Bottomnavigation> createState() => _BottomnavigationState();
}

class _BottomnavigationState extends State<Bottomnavigation> {
  @override
 int _selectedIndex = 0;

 final _widgetOptions = [
        FlutterDemo(),
        Video_Home(),
        Music(),
        Playlist_Screen(),
      ];

Widget icons(IconData icon,int selceted){
  return Icon(icon,color: selceted== _selectedIndex?Theme.of(context).iconTheme.color:Theme.of(context).secondaryHeaderColor,);
}

   Widget _bottomNavigation() {
    return BottomNavigationBar(
      items:  <BottomNavigationBarItem>[
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
      ],
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
  Widget build(BuildContext context) {
    return Scaffold(
      //body: IndexedStack(children:_widgetOptions,index: _selectedIndex,) ,
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: _bottomNavigation(),
    );

  }
}