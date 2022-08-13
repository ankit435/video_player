
import 'package:flutter/widgets.dart';
import 'package:video_player/video_player.dart';

class folder with ChangeNotifier{

  final int f_id;
   String f_title;
  final String f_path;
  // ignore: non_constant_identifier_names
  List<video> f_detail=[];
  final DateTime f_timestamp;
   int f_size;

  folder({
    required this.f_id,
    required this.f_title,
    required this.f_path,
    required this.f_detail,
    required this.f_timestamp,
    required this.f_size,
  });

}

// ignore: non_constant_identifier_names


class video with ChangeNotifier{

  final int  v_id;
  final int parent_folder_id;
  String v_title;
  final String v_videoPath;
  final String v_thumbnailPath;
  int v_duration;
  final DateTime v_timestamp;
  int v_watched;
  final int v_size;
  final DateTime v_lastmodified;
  bool v_favourite;
  bool v_open;

   video({
    required this.v_id,
    required this.parent_folder_id,
    required this.v_title,
    required this.v_thumbnailPath,
    required this.v_videoPath,
    required this.v_duration,
    required this.v_timestamp,
    required this.v_watched,
    required this.v_lastmodified,
    required this.v_size,
    this.v_favourite=false,
    this.v_open=false,
  });
 void toggleBoostStatus() {
    v_open = true;
    notifyListeners();
  }
  void togglefavstatus() {
    v_favourite = !v_favourite;
    notifyListeners();
  }

}


class queue_player with ChangeNotifier{
  VideoPlayerController? controller;
  int curentindex;
  List<video>queue_video_list =[];
  bool b_play;

   queue_player({
    this.controller=null,
    required this.curentindex,
    required this.queue_video_list,
    this.b_play=false,
    
  });



  

}

class favourite with ChangeNotifier{

  final int v_id;
   String v_title;
  final String v_videoPath;
  final String v_thumbnailPath;
  final String v_duration;
  final DateTime v_timestamp;
  final String v_watched;
  bool v_favourites;
 
  bool v_open;

   favourite({
    required this.v_id,
    required this.v_title,
    required this.v_thumbnailPath,
    required this.v_videoPath,
    required this.v_duration,
    required this.v_timestamp,
    required this.v_watched,
    this.v_favourites=false,
    this.v_open=false,

  });
 void toggleBoostStatus() {
    v_open = true;
    notifyListeners();
  }
  void togglefavstatus() {
    
    notifyListeners();
  }
  
}




class Hide_list with ChangeNotifier{


  final int h_id;
  final String h_path;

Hide_list({
  required this.h_id,
  required this.h_path,
});
}


class PlayList with ChangeNotifier{

  final int p_id;
  String p_title;
  List<video> p_detail=[];

PlayList({

required this.p_id,
required this.p_title,
required this.p_detail,
});

  items() {}
}