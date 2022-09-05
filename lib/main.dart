


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video/file/file.dart';



import 'package:video/properties/setting.dart';
import 'package:video/search/search.dart';
import 'package:video/theme/theme_constants.dart';
import 'package:video/theme/theme_create.dart';

import 'Playlist/playlist_file.dart';
import 'Playlist/video_song_screen/video_and_song_screent.dart';
import 'helper/files.dart';

import 'permission/permission.dart';
import 'theme/theme_manager.dart';
import 'theme/theme_screen.dart';
import 'video_player/video_play.dart';
ThemeManager _themeManager = ThemeManager();

void main() {


  runApp(MultiProvider(providers: [ChangeNotifierProvider<themes>(create: (_)=>themes(),)], child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Brightness? _brightness;
    @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _brightness = WidgetsBinding.instance.window.platformBrightness;
    _themeManager.addListener(themeListener);
    super.initState();
  }

  @override
  void dispose() {
    _themeManager.removeListener(themeListener);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  themeListener(){
    if(mounted){
      setState(() {

      });
    }
  }
  @override
  void didChangePlatformBrightness() {
    if (mounted) {
      setState(() {
        _brightness = WidgetsBinding.instance.window.platformBrightness;
      });
    }
    super.didChangePlatformBrightness();
  }



  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        
        
       ChangeNotifierProvider.value(
          value: folder_details()
        ),
        ChangeNotifierProvider.value(
          value: favourite_details()
        ),
        ChangeNotifierProvider.value(
          value: video_details()
        ),
         ChangeNotifierProvider.value(
          value: PlayList_detail()
        ),
        ChangeNotifierProvider.value(
          value: queue_playerss()
        ),

        
    ],
    child :MaterialApp(
      title: 'Video',
      //theme: _brightness == Brightness.dark ?  darkTheme :lightTheme,
      theme:Provider.of<themes>(context).getThemeById(2).themeData,
      darkTheme: darkTheme,
      themeMode: _themeManager.themeMode,
      home:ImageScreen(),
      // FlutterDemo(title:"Lol",storage: Storage()),
      routes: {
        Search.routeName: (ctx) => const Search(),
        Files.routeName:(ctx)=> Files(),
        //Setting.routeName:(ctx)=>const Setting(),
        Playlist_file.routeName:(context) => const Playlist_file(),
        Videos_And_Songs.routeName:(context) => Videos_And_Songs(),
        theme_screen.routeName:(context) => theme_screen(),
        Create_theme.routeName:(context) => Create_theme(),
        Play_video.routeName:(context) => Play_video(),

      },
    ),);
  }
}