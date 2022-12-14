import 'dart:convert';

import 'package:flutter/material.dart';


// final String folder_databasename  = 'folder_databasename';
// final String playlist_databasename = 'Playlists';
// final String Video_databasename = 'Videos_database';

// class folder_database{
//   static final  List<String> values = [

//   id,folder_name,folder_size,folder_date,folder_path

//   ];
//   static final String id = '_id';
//   static final String folder_name = 'folder_name';
//   static final String folder_path = 'folder_path';
//   static final String folder_size = 'folder_size';
//   static final String folder_date = 'folder_date';
// }

// class playlist_database{
//   static final  List<String> values = [

//   id,playlist_name,playlist_thumbnail_path

//   ];
//   static final String id = '_id';
//   static final String playlist_name = 'playlist_name';
//   static final String playlist_thumbnail_path = 'playlist_thumbnail_path';

// }

// class video_database{
//   static final  List<dynamic> values = [
//   id,Video_name,Video_path,Video_size,Video_date,Video_duration, Video_type,Video_folder_id, Video_playlist_id, Video_thumbnail_path,Video_open,Video_lastmodified,Video_favourite
//   ];

//   static final String id = '_id';
//   static final String Video_name = 'Video_name';
//   static final String Video_path = 'Video_path';
//   static final String Video_size = 'Video_size';
//   static final String Video_date = 'Video_date';
//   static final String Video_duration = 'Video_duration';
//   static final String Video_watched = 'Video_watched';
//   static final String Video_type = 'Video_type';
//   static final String Video_folder_id = 'Video_folder';
//   static final String Video_playlist_id = 'Video_playlist';
//   static final String Video_thumbnail_path = 'Video_thumbnail_path';
//   static final int Video_open = 0;
//   static final int Video_favourite = 0;
//   static final String Video_lastmodified="Video_lastmodified";

// }

class folder with ChangeNotifier {
  final String f_id;
  String f_title;
  String f_path;
  // ignore: non_constant_identifier_names
  List<video> f_detail = [];
  final DateTime f_timestamp;
  int f_size;
  bool show = false;
  List<Music>f_music = [];

  folder({
    required this.f_id,
    required this.f_title,
    required this.f_path,
    required this.f_detail,
    required this.f_timestamp,
    required this.f_size,
    this.show=false,
    required this.f_music,
  });
}
class Music with ChangeNotifier {
  final String m_id;
  String m_title;
  String m_path;
  bool show = false;
  String m_f_id;
  String? m_artist;
  String? m_album;
  String? m_duration;
  String? m_thumbnail;
  String? m_albumart;
  String? m_discnumber;
  String? m_lyrics;
  String? m_format;
  String? m_filesize;
  String? m_filetype;
  String? m_fileextension;
  
  String? m_playlist;
  String? m_lastmodified;




  Music({
    required this.m_id,
    required this.m_f_id,
    required this.m_title,
    required this.m_path,
    this.show=false,
  });

}

class video with ChangeNotifier {
  final String v_id;
  final String parent_folder_id;
  String v_title;
  String v_videoPath;
  String? v_thumbnailPath = null;
  int v_duration;
  final DateTime v_timestamp; //
  int v_watched;
  final int v_size;
  final DateTime v_lastmodified;
  bool v_favourite;
  bool v_open;
  final DateTime ListedTime;
  Set<String> playlist_id = {};

  video({
    required this.v_id,
    required this.parent_folder_id,
    required this.v_title,
    this.v_thumbnailPath,
    required this.v_videoPath,
    required this.v_duration,
    required this.v_timestamp,
    required this.v_watched,
    required this.v_lastmodified,
    required this.v_size,
    this.v_favourite = false,
    this.v_open = false,
    required this.ListedTime,
    required this.playlist_id,

    //this.ListedTime,

    // ignore: non_constant_identifier_names
  });
  void toggleBoostStatus() {
    v_open = true;
    notifyListeners();
  }

  void togglefavstatus() {
    v_favourite = !v_favourite;
    notifyListeners();
  }

  toJson() {
    return {
      'v_id': v_id,
      'parent_folder_id': parent_folder_id,
      'v_title': v_title,
      'v_videoPath': v_videoPath,
      'v_thumbnailPath': v_thumbnailPath,
      'v_duration': v_duration,
      'v_timestamp': v_timestamp.toIso8601String(),
      'v_watched': v_watched,
      'v_lastmodified': v_lastmodified.toIso8601String(),
      'v_size': v_size,
      'v_favourite': v_favourite?1:0,
      'v_open': v_open?1:0,
      'playlist_id': playlist_id.toString(),
      'ListedTime': ListedTime.toIso8601String(),
       
    };
  }

  factory video.fromJson(e) {
    return video(
      v_id: e['v_id'],
      parent_folder_id: e['parent_folder_id'],
      v_title: e['v_title'],
      v_videoPath: e['v_videoPath'],
      v_thumbnailPath: e['v_thumbnailPath'],
      v_duration: e['v_duration'],
      v_timestamp: DateTime.parse(e['v_timestamp']),
      v_watched: e['v_watched'],
      v_lastmodified: DateTime.parse(e['v_lastmodified']),
      v_size: e['v_size'] ,
      v_favourite: e['v_favourite']==1?true:false,
      v_open: e['v_open']==1?true:false,
      playlist_id: e['playlist_id'].toString().split(',').toSet(),
      ListedTime: DateTime.parse(e['ListedTime']),
    
    );
  }

  video copy({    
    String? v_id,
    String? parent_folder_id,
    String? v_title,
    String? v_videoPath,
    String? v_thumbnailPath,
    int? v_duration,
    DateTime? v_timestamp,
    int? v_watched,
    DateTime? v_lastmodified,
    int? v_size,
    bool? v_favourite,
    bool? v_open,
    DateTime? ListedTime,
    Set<String>? playlist_id,
  }) {
    return video(
      v_id: v_id ?? this.v_id,
      parent_folder_id: parent_folder_id ?? this.parent_folder_id,
      v_title: v_title ?? this.v_title,
      v_videoPath: v_videoPath ?? this.v_videoPath,
      v_thumbnailPath: v_thumbnailPath ?? this.v_thumbnailPath,
      v_duration: v_duration ?? this.v_duration,
      v_timestamp: v_timestamp ?? this.v_timestamp,
      v_watched: v_watched ?? this.v_watched,
      v_lastmodified: v_lastmodified ?? this.v_lastmodified,
      v_size: v_size ?? this.v_size,
      v_favourite: v_favourite ?? this.v_favourite,
      v_open: v_open ?? this.v_open,
      ListedTime: ListedTime ?? this.ListedTime,
      playlist_id: playlist_id ?? this.playlist_id,
    );
  }
  
}






// final String Video_databasename = 'Video_Table';


// class video_database{


// static final List<String> values =[ 
//   Video_id,Video_name,Video_path,Video_size,Video_date,Video_duration,Video_folder_id, Video_thumbnail_path,Video_open,Video_lastmodified,Video_favourite,Video_watched,Video_playlist_id
//   ];

//  // static final String Video_table = 'Video_Table';
//   static final String Video_id = 'v_id';
//   static final String Video_name = 'v_title';
//   static final String Video_path = 'v_videoPath';
//   static final String Video_size = 'v_size';
//   static final String Video_date = 'v_timestamp';
//   static final String Video_duration = 'v_duration';
//   static final String Video_watched = 'v_watched';
//   static final String Video_folder_id = 'parent_folder_id';
//   static final String Video_thumbnail_path = 'v_thumbnailPath';
//   static final String Video_open = "v_open";
//   static final String Video_favourite = "v_favourite";
//   static final String Video_lastmodified="v_lastmodified";
//   static final String Video_ListedTime="ListedTime";
//   static final String Video_playlist_id="playlist_id";


 




// }


// class favourite with ChangeNotifier {
//   final int v_id;
//   String v_title;
//   final String v_videoPath;
//   final String v_thumbnailPath;
//   final String v_duration;
//   final DateTime v_timestamp;
//   final String v_watched;
//   bool v_favourites;

//   bool v_open;

//   favourite({
//     required this.v_id,
//     required this.v_title,
//     required this.v_thumbnailPath,
//     required this.v_videoPath,
//     required this.v_duration,
//     required this.v_timestamp,
//     required this.v_watched,
//     this.v_favourites = false,
//     this.v_open = false,
//   });
//   void toggleBoostStatus() {
//     v_open = true;
//     notifyListeners();
//   }

//   void togglefavstatus() {
//     notifyListeners();
//   }
// }

// class Hide_list with ChangeNotifier {
//   final int h_id;
//   final String h_path;

//   Hide_list({
//     required this.h_id,
//     required this.h_path,
//   });
// }

class PlayList with ChangeNotifier {
  final String p_id;
  String p_title;
  List<video> p_detail = [];
  int count = 0;
  String p_thumbnailPath = "";
  String? curr_played_video_id = null;

  PlayList({
    required this.p_id,
    required this.p_title,
    required this.p_detail,
    this.count = 0,
    this.p_thumbnailPath = "",
  });

  Map<String, dynamic> toJson() {
    return {
      playlist_database.id: p_id,
      playlist_database.playlist_name: p_title,
      playlist_database.count: count,
      playlist_database.p_thumbnailPath: p_thumbnailPath,
      playlist_database.p_detail:
          jsonEncode(p_detail.map((e) => e.toJson()).toList()).toString(),
    };
  }

  PlayList.fromJson(Map<String, dynamic> json)
      : p_id = json[playlist_database.id],
        p_title = json[playlist_database.playlist_name],
        count = json[playlist_database.count],
        p_thumbnailPath = json[playlist_database.p_thumbnailPath],
        p_detail = jsonDecode(json[playlist_database.p_detail])
            .map<video>((e) => video.fromJson(e))
            .toList();

  PlayList copy({
    String? p_id,
    String? p_title,
    List<video>? p_detail,
    int? count = 0,
    String? p_thumbnailPath = "",
  }) {
    return PlayList(
      p_id: p_id ?? this.p_id,
      p_title: p_title ?? this.p_title,
      p_detail: p_detail ?? this.p_detail,
      count: this.count,
      p_thumbnailPath: this.p_thumbnailPath,
    );
  }
}

final String playlist_databasename = 'playlist_Table';

class playlist_database {
  static final List<String> values = [id, playlist_name, p_detail];
  static final String id = 'p_id';
  static final String playlist_name = 'p_title';
  static final String p_detail = 'p_detail';
  static final String count = 'count';
  static final String p_thumbnailPath = 'p_thumbnailPath';
}

// class Thumbail_path with ChangeNotifier {
//   final String v_videoPath;
//   final String v_thumbnailPath;
//   //final String t

//   Thumbail_path({
//     required this.v_videoPath,
//     required this.v_thumbnailPath,
//   });

//   Map<String, Object?> toMap() {
//     return {
//       'v_videoPath': v_videoPath,
//       'v_thumbnailPath': v_thumbnailPath,
//     };
//   }

//   static Thumbail_path fromMap(Map<String, Object?> map) {
//     return Thumbail_path(
//       v_videoPath: map['v_videoPath'] as String,
//       v_thumbnailPath: map['v_thumbnailPath'] as String,
//     );
//   }

// // Thumbail_path copy({
// //   String? v_videoPath,
// //   String? v_thumbnailPath,
// // }) {
// //   return
// //   Thumbail_path(
// //     v_videoPath: v_videoPath ?? this.v_videoPath,
// //     v_thumbnailPath: v_thumbnailPath ?? this.v_thumbnailPath,
// //   );
// // }

//   Map<String, Object?> toJson() {
//     return {
//       'v_videoPath': v_videoPath,
//       'v_thumbnailPath': v_thumbnailPath,
//     };
//   }

//   static fromJson(Map<String, Object?> first) {
//     return Thumbail_path(
//       v_videoPath: first['v_videoPath'] as String,
//       v_thumbnailPath: first['v_thumbnailPath'] as String,
//     );
//   }

// }

// final String video_thumbailedatabase  = 'video_thumbailedatabase';

// class video_thumbnail{
//    static final  List<String> values = [
//   v_videoPath,v_thumbnailPath

//   ];

//   static final String v_thumbnailPath = 'v_thumbnailPath';
//   static final String v_videoPath = 'v_videoPath';
//   //static final String v_duration = 'v_duration';
// }

final String Recent_database = 'Recent_database';

class Recent_video {
  static final List<String> values = [R_video_id, time_stamp, videos];

  static final String R_video_id = "R_video_id";
  static final String videos = "videos";
  static final String time_stamp = "time_stamp";
}

class recent_video with ChangeNotifier {
  String R_video_id;
  video videos;
  int time_stamp;
  recent_video(
      {required this.R_video_id,
      required this.videos,
      required this.time_stamp});

  Map<String, Object?> toJson() {
    return {
      Recent_video.R_video_id: R_video_id,
      Recent_video.time_stamp: time_stamp,
      Recent_video.videos: jsonEncode(videos.toJson()).toString(),
    };
  }

  recent_video copy({
    String? R_video_id,
    video? videos,
    int? time_stamp,
  }) =>
      recent_video(
        R_video_id: R_video_id ?? this.R_video_id,
        videos: videos ?? this.videos,
        time_stamp: time_stamp ?? this.time_stamp,
      );

  recent_video.fromJson(Map<String, dynamic> json)
      : R_video_id = json[Recent_video.R_video_id],
        time_stamp = json[Recent_video.time_stamp],
        videos = video.fromJson(jsonDecode(json[Recent_video.videos]));
}


