


import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/Music/Tabbar/Album.dart';
import 'package:video/Music/Tabbar/Artist.dart';
import 'package:video/Music/Tabbar/Songs.dart';
import 'package:video/helper/storage.dart';

import '../Music_player/Music_play_screent.dart';
import '../helper/files.dart';
import 'Tabbar/Folder.dart';

class Music_Screen extends StatefulWidget {
  const Music_Screen({Key? key}) : super(key: key);

  @override
  State<Music_Screen> createState() => _MusicState();
}

class _MusicState extends State<Music_Screen> {
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
     Widget text(String text,{TextStyle? style,double size=16,maxLines,Color? color,FontWeight? weight , TextAlign align= TextAlign.start,}) {
    return AutoSizeText(text,
    maxLines: maxLines,
    textAlign:align,
    overflow: TextOverflow.ellipsis,
    style: style?? TextStyle(
      color:color?? Theme.of(context).textTheme.bodyText1!.color,
      fontSize: size,
      fontWeight: weight,
    //  fontFamily: 'Roboto',
    ),);

  }
    Widget icons(IconData icon) {
    return Icon(
      icon,
      color: Theme.of(context).iconTheme.color,
    );
  }
  
void _music_plyers_screen(BuildContext context,String? path) {
   
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      isScrollControlled: true,
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            //contdition to be ture for one video
            child: Music_play_screen(m_path: path,));
      },
    );
  }
  
  Widget iconbutton(IconData? icon, Function? param1, {String? text =null}) {
    return SizedBox.fromSize(
      size: Size(56, 56), // button width and height
      child: ClipOval(
        child: Material(
          color: Colors.transparent, // button color
          child: InkWell(
            splashColor: Colors.green, // splash color
            onTap: () {
              param1!();
              
            }, // button pressed
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                text==null
                    ? icons(icon!)
                    : FittedBox(
                        child: Text(
                        "${text}",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ))
                // text
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String? m_path=Provider.of<Audio_player>(context, listen: true).get_audio_path();
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
        body: Stack(
          

          children:  [
            TabBarView(children: [
              Songs(music_plyers_screen:_music_plyers_screen),Folders(),Artists(),Albums(),
            ],

            
            ),

          Provider.of<Audio_player>(context, listen: true).get_is_mounted()?
           Align (
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading: icons(Icons.music_note),
                title: text(Storage().get_file_title(m_path ?? 'No Music.mp3')),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    iconbutton(Provider.of<Audio_player>(context, listen: true).get_is_playing()?Icons.pause_circle_outline_outlined :Icons.play_circle_outline_outlined, (){ Provider.of<Audio_player>(context, listen: false).play_pause();}),
                    iconbutton(Icons.skip_next, (){}),
                  ],
                  ),
                  onTap: (){
                  _music_plyers_screen(context, m_path);
                  },
              ),
            ):const SizedBox(),
          ],
        ),
    
      ),
    )
    );



// ignore: dead_code
}


}
