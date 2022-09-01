


import 'package:flutter/material.dart';
import 'package:video/Music/Tabbar/Album.dart';
import 'package:video/Music/Tabbar/Artist.dart';
import 'package:video/Music/Tabbar/Songs.dart';

import 'Tabbar/Folder.dart';

class Music extends StatefulWidget {
  const Music({Key? key}) : super(key: key);

  @override
  State<Music> createState() => _MusicState();
}

class _MusicState extends State<Music> {
bool selection = false;
  int icons_value = 0;


    Widget _Popups() {
    return PopupMenuButton(
        itemBuilder: (context) => [
                PopupMenuItem(
                    onTap: () => (){},
                    child: ListTile(
                      leading: Icon(Icons.select_all),
                      title: Text("Select"),
                    )),
                const PopupMenuItem(
                    child: ListTile(
                  leading: Icon(Icons.sort),
                  title: Text("sort by"),
                )),
              ]);
  }

  List<Widget> action() {
    return ([
            IconButton(
              onPressed: (() {
                print("file click");
                      
              }),
              icon: Icon(Icons.lock_rounded),
            ),
            IconButton(
              onPressed: (){},
              icon: Icon(Icons.delete),
            ),
            _Popups(),
          ]
    );
  }
  @override
  Widget build(BuildContext context) {
    
    return DefaultTabController (
      length: 4,
      child: Scaffold(
      
        body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar( 
       backgroundColor: Theme.of(context).primaryColor,
            pinned: true,
            floating: true,
            snap: true,
            title: Text("Music"),
            actions: action(),
            bottom: TabBar(tabs: [Tab(text: "Song",),Tab(text: "Folder",),Tab(text: "Album",),Tab(text: "Artist",)]),
            ),
        ],
        body: const TabBarView(children: [
          Songs(),Folders(),Artists(),Albums(),
        ],),
    
      ),
    )
    );



// ignore: dead_code
}


}
