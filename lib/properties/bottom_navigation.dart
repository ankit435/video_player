



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

Widget icons(IconData icon){
  return Icon(icon,color:Theme.of(context).secondaryHeaderColor,);
}

   Widget _bottomNavigation() {
    return BottomNavigationBar(
      items:  <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: icons(Icons.home),
          label: 'Home',
          
        ),
        BottomNavigationBarItem(
          icon: icons(Icons.video_library),
          label: 'Video',
        ),
        BottomNavigationBarItem(
          icon: icons(Icons.my_library_music_outlined),
          label: 'Muisc',
        ),
        BottomNavigationBarItem(
          icon: icons(Icons.favorite,),
          label: 'favorite',
          
        ),
      ],
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      backgroundColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).primaryIconTheme.color,
      selectedFontSize:
          Theme.of(context).textTheme.titleMedium!.fontSize!.toDouble(),
      unselectedFontSize:
          Theme.of(context).textTheme.titleMedium!.fontSize!.toDouble(),
      selectedItemColor: Theme.of(context).secondaryHeaderColor,
      
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