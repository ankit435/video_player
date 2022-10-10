


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video/file/file.dart';
import 'package:video/home/home.dart';
import 'package:video/helper/neo_player/player.dart';
import 'package:video/properties/manage_scanlist.dart';



import 'package:video/properties/setting.dart';
import 'package:video/search/search.dart';
import 'package:video/showdialogbox/Decoder.dart';
import 'package:video/theme/theme_constants.dart';
import 'package:video/theme/theme_create.dart';

import 'Music_player/Music_play_screent.dart';
import 'Playlist/playlist_file.dart';
import 'Playlist/video_song_screen/video_and_song_screent.dart';
import 'helper/files.dart';

import 'permission/permission.dart';
import 'theme/theme_manager.dart';
import 'theme/theme_screen.dart';
import 'video_player/video_play.dart';

//ThemeManager _themeManager = ThemeManager();

Future<void> main() async {


WidgetsFlutterBinding.ensureInitialized();
  var pref=await SharedPreferences.getInstance();
  await pref.setBool('init_data', true);
  var theme_id;
  if(pref.containsKey('theme_id')){
    theme_id=pref.getInt('theme_id');
  }
  else{
    theme_id=1;
  }
  await playerDatabase.instance;
  runApp(MultiProvider(providers: [ChangeNotifierProvider<themes>(create: (_)=>themes(theme_id),),ChangeNotifierProvider<Setting_data>(create: (_)=>Setting_data(),)  ], child: MyApp()));
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
     Provider.of<Setting_data>(context, listen: false).set_setting_data();
    WidgetsBinding.instance.addObserver(this);
    _brightness = WidgetsBinding.instance.window.platformBrightness;
   // _themeManager.addListener(themeListener);
    super.initState();
  }

  @override
  void dispose() {
   // _themeManager.removeListener(themeListener);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  // themeListener(){
  //   if(mounted){
  //     setState(() {

  //     });
  //   }
  // }
  @override


Future<void> loaddata() async {
   var pref=await SharedPreferences.getInstance();
    await pref.setBool('init_data', true);
}


  void didChangePlatformBrightness() {
    if (mounted) {
      setState(() {
       
        loaddata();
        _brightness = WidgetsBinding.instance.window.platformBrightness;
      });
    }
    super.didChangePlatformBrightness();
  }



  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Video_player()),
        ChangeNotifierProvider.value(value: Audio_player()),

        ChangeNotifierProvider.value(value: recent_videos()),
        
       ChangeNotifierProvider.value(
          value: folder_details()
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
      theme:Provider.of<themes>(context).getThemeById().themeData,
      darkTheme: _brightness == Brightness.dark ?   ThemeData.dark() : ThemeData.light(),
     
     /// themeMode: _themeManager.themeMode,
      home:ImageScreen(),
      // FlutterDemo(title:"Lol",storage: Storage()),
      routes: {
        FlutterDemo.routeName: (ctx) => FlutterDemo(),
        Search.routeName: (ctx) => const Search(),
        // Files.routeName:(ctx)=> Files(),
        Setting.routeName:(ctx)=> Setting(),
        //Playlist_file.routeName:(context) => const Playlist_file(),
       // Videos_And_Songs.routeName:(context) => Videos_And_Songs(),
        theme_screen.routeName:(context) => theme_screen(),
        Create_theme.routeName:(context) => Create_theme(),
        Play_video.routeName:(context) => Play_video(),
        Manage_scan_list.routeName:(context) => Manage_scan_list(),
       // Music_play_screen.routeName:(context) => Music_play_screen(),

      },
    ),);
  }
}