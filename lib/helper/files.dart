// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video/Playlist/playlist_file.dart';
import 'package:video/helper/file.dart';
import 'package:video/helper/storage.dart';
import 'package:video/helper/theme_model.dart';
import 'package:video/theme/theme_constants.dart';
import 'package:video_player/video_player.dart';

import 'neo_player/player.dart';

class themes with ChangeNotifier {
  final List<theme> _themes_data = [
    theme(theme_id: 0, brightness: Brightness.dark, themeData: ThemeData()),
    theme(
        theme_id: 1, brightness: Brightness.dark, themeData: ThemeData.dark()),
    theme(
        theme_id: 2,
        brightness: Brightness.light,
        themeData: ThemeData(
          primarySwatch: Colors.green,
          primaryColor: Colors.green,
          brightness: Brightness.light,
          secondaryHeaderColor: Colors.white,

          //backgroundColor:  Color.fromARGB(255, 14, 146, 89),
          accentColor: Colors.black,
          accentIconTheme: IconThemeData(color: Colors.white),
          dividerColor: Colors.black12,
          // iconTheme: IconThemeData(color: Colors.green),
          // textTheme: TextTheme(
          //   bodyText1: TextStyle(color: Colors.green),
          // ),
          sliderTheme: SliderThemeData(
            activeTrackColor: Colors.green,
            inactiveTrackColor: Colors.blue,
            thumbColor: Colors.white,
            overlayColor: Colors.black.withAlpha(120),
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
          ),
        )),
    theme(
        theme_id: 3,
        brightness: Brightness.dark,
        themeData: ThemeData(
          primarySwatch: Colors.red,
          primaryColor: Colors.red,
          secondaryHeaderColor: Color.fromARGB(255, 77, 3, 251),
          brightness: Brightness.light,
          backgroundColor: Color.fromARGB(255, 146, 40, 40),
          accentColor: Colors.black,
          accentIconTheme:
              IconThemeData(color: Color.fromARGB(255, 145, 19, 19)),
          dividerColor: Color.fromARGB(31, 201, 180, 180),
          // iconTheme: IconThemeData(color: Colors.blue),
          // textTheme: TextTheme(
          //   bodyText1: TextStyle(color: Colors.red), //<-- SEE HERE
          // ),

          checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.all(Colors.red),
            checkColor: MaterialStateProperty.all(Colors.white),
          ),
        )),
    theme(
        theme_id: 4,
        brightness: Brightness.values[Random().nextInt(2)],
        themeData: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Colors.blue,
          secondaryHeaderColor: Color.fromARGB(255, 40, 23, 75),
          brightness: Brightness.light,
          backgroundColor: Color.fromARGB(255, 40, 23, 75),
          accentColor: Colors.black,
          primaryIconTheme:
              IconThemeData(color: Color.fromARGB(255, 7, 230, 18)),
          accentIconTheme:
              IconThemeData(color: Color.fromARGB(255, 214, 9, 57)),
          dividerColor: Color.fromARGB(31, 201, 180, 180),
          // iconTheme: IconThemeData(color: Color.fromARGB(255, 15, 107, 206)),
          iconTheme: IconThemeData(color: Color.fromARGB(255, 7, 230, 18)),
          textTheme: TextTheme(
            bodyText1: TextStyle(
                color: Color.fromARGB(255, 9, 236, 43)), //<-- SEE HERE
          ),
        )),
  ];

  themes(int theme_id) {
    themes_data[0].curr_thenme_id = theme_id;
  }
  List<theme> get themes_data => _themes_data;

  theme getThemeById({int? id}) {
    return _themes_data.firstWhere(
        (theme) => theme.theme_id == _themes_data[0].curr_thenme_id);
  }

  // void update_curr_theme(int id) {
  //   _themes_data.forEach((theme) {
  //     if (theme.theme_id == id) {
  //       theme.themeData.brightness == Brightness.dark
  //           ? SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light)
  //           : SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  //       curr_theme = theme;
  //     }
  //   });
  // }

  void update_curr_theme_id(int id) async {
    var pref = await SharedPreferences.getInstance();
    pref.setInt('theme_id', id);

    _themes_data[0].curr_thenme_id = id;
    notifyListeners();
  }

  void addTheme(Brightness brightness, ThemeData themeData) {
    _themes_data.add(theme(
        theme_id: _themes_data.length + 1,
        brightness: brightness,
        themeData: themeData));
    notifyListeners();
  }

  void removeTheme(theme theme) {
    _themes_data.remove(theme);
    notifyListeners();
  }

  void changeTheme(int id) {
    theme themes = getThemeById();
    for (var element in _themes_data) {
      if (element.theme_id == id) {
        element.themeData = themes.themeData;
        element.brightness = themes.brightness;
      }
    }
    notifyListeners();
  }

  void changeBrightness(int id) {
    theme themes = getThemeById();
    for (var element in _themes_data) {
      if (element.theme_id == id) {
        element.themeData = themes.themeData;
        element.brightness = themes.brightness;
      }
    }
    notifyListeners();
  }

  void changeThemeData(int id, ThemeData themeData) {
    theme themes = getThemeById();
    for (var element in _themes_data) {
      if (element.theme_id == id) {
        element.themeData = themeData;
      }
    }
    notifyListeners();
  }

  void changeBrightnessData(int id, Brightness brightness) {
    theme themes = getThemeById();
    for (var element in _themes_data) {
      if (element.theme_id == id) {
        element.themeData = themes.themeData;
        element.brightness = brightness;
      }
    }
    notifyListeners();
  }

  void changeThemeDataData(int id, ThemeData themeData) {
    theme themes = getThemeById();
    for (var element in _themes_data) {
      if (element.theme_id == id) {
        element.themeData = themeData;
      }
    }
    notifyListeners();
  }
}

class folder_details with ChangeNotifier {
  List<folder> _folder_item = [];

  List<video>? findById(int id) {
    final index = _folder_item.indexWhere((folder) => folder.f_id == id);
    return _folder_item[index].f_detail;
  }

  Future<bool> fetchdatabase() async {
    try {
      _folder_item = await Storage().localPath();
      var db = await playerDatabase.instance;

      // for (int i = 0; i < _folder_item.length; i++) {
      //   for (int j = 0; j < _folder_item[i].f_detail.length; j++) {
      //     try {
      //       _folder_item[i].f_detail[j] =
      //           (await db.getvideo_by_v_id(_folder_item[i].f_detail[j].v_id));
      //     } catch (e) {
      //       print(e);
      //       await db.add_video_database(_folder_item[i].f_detail[j]);
      //     }
      //   }
      // }

      notifyListeners();

      return true;
    } catch (e) {
      print(e);
      throw e;
    }
  }




  // Future<video> update_Video_database(video v) async {
  //   var db = await playerDatabase.instance;
  //   return await db.update_video_database(v);
  //   // notifyListeners();
  // }


//   Future<video> rename_file_database(video v,String new_path,String new_title) async {
//     var db = await playerDatabase.instance;
//     try {
//       video Copy_v=(await  db.delete_video_database(v));
//       print(v.v_id);
//       return await db.add_video_database(video(v_id: new_path, parent_folder_id: v.parent_folder_id, v_title: new_title, v_videoPath: new_path, v_duration: v.v_duration, v_timestamp: v.v_timestamp, v_watched: v.v_watched, v_lastmodified: v.v_lastmodified, v_size: v.v_size, ListedTime:v. ListedTime, playlist_id: v.playlist_id,v_thumbnailPath: null));
//     } catch (e) {
//       print(e);
//       throw Exception("field to rename file");
//     }
  
//   }

//  Future<String> Rename_folder_databse(String f_older_path,String new_path ) async{

//     try {
//           var db = await playerDatabase.instance;
//           return await db.rename_folder_path(f_older_path, new_path);
      
//     } catch (e) {
//       throw Exception ("failder to rename folder");
//     }

//   }




  



  List<folder> items() {
    return _folder_item;
  }

  List<video> getAllvideo() {
    List<video> videos = [];
    for (var element in _folder_item) {
      videos.addAll(element.f_detail);
    }

    return videos;
  }

  int folder_index(String fId) {
    int index = _folder_item.indexWhere((element) => element.f_id == fId);
    return index;
  }

  List<video> getfolderIdvideo(String fId) {
    return _folder_item[folder_index(fId)].f_detail;
  }

  int folder_video_index(int fIndex, String vId) {
    int index =
        _folder_item[fIndex].f_detail.indexWhere((video) => video.v_id == vId);
    return index;
  }

  int gettotalvideosize() {
    int size = 0;
    for (var element in _folder_item) {
      size += element.f_size;
    }

    return size;
  }

  int gefoldersize(String fId) {
    return _folder_item[folder_index(fId)].f_size;
  }

  String getfoldername(String fId) {
    return _folder_item[folder_index(fId)].f_title;
  }

  // void thumbailedatabase(String f_id, String v_id, String thumail) async{
  //   final db = await playerDatabase.instance;
  //       // db.create_thumbaile(v_id, thumail,duration: f_id);
  // }

  String? getthumbailpath(String fId, String vId) {
    int fIndex = folder_index(fId);
    int vIndex = folder_video_index(fIndex, vId);

    return _folder_item[fIndex].f_detail[vIndex].v_thumbnailPath;
  }

 Future< bool> setthumail(String fId, String vId, String thumail) async{
    try {
        int f_index=folder_index(fId);
        int v_index=folder_video_index(folder_index(fId), vId);
        video v=_folder_item[f_index].f_detail[v_index];
        v.v_thumbnailPath=thumail;
      //  _folder_item[f_index].f_detail[v_index]=(await update_Video_database(v));
       _folder_item[f_index].f_detail[v_index]=v;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  List<video> getfoldertotalvideo(String fId, String sort, bool sortrevrsed) {
    if (sort == 'Name') {
      _folder_item[folder_index(fId)].f_detail.sort((a, b) {
        return a.v_title.toLowerCase().compareTo(b.v_title.toLowerCase());
      });
    } else if (sort == "Date") {
      _folder_item[folder_index(fId)].f_detail.sort((a, b) {
        return a.v_timestamp.compareTo(b.v_timestamp);
      });
    } else if (sort == "Length") {
      _folder_item[folder_index(fId)].f_detail.sort((a, b) {
        return a.v_duration.compareTo(b.v_duration);
      });
    } else if (sort == "Size") {
      _folder_item[folder_index(fId)].f_detail.sort((a, b) {
        return a.v_size.compareTo(b.v_size);
      });
    }

    if (sortrevrsed) {
      return _folder_item[folder_index(fId)].f_detail.reversed.toList();
    }
    return _folder_item[folder_index(fId)].f_detail;
  }

  Map<String, Set<String>> delete_file(Map<String, String> selctionList) {
    Map<String, Set<String>> removePlayList = {};
    try {
      selctionList.forEach((vId, fId) {
        int fIndex = folder_index(fId);
        int index = folder_video_index(fIndex, vId);

        if (Storage()
            .deleteFile(_folder_item[fIndex].f_detail[index].v_videoPath)) {
          _folder_item[fIndex].f_size = (_folder_item[fIndex].f_size) -
              (_folder_item[fIndex].f_detail[index].v_size);

          for (var PId in _folder_item[fIndex].f_detail[index].playlist_id) {
            if (removePlayList.containsKey(PId)) {
              removePlayList[PId]!.add(vId);
            } else {
              removePlayList[PId] = Set();
              removePlayList[PId]!.add(vId);
            }
          }
          _folder_item[fIndex].f_detail.removeAt(index);
        }
      });
      notifyListeners();

      return removePlayList;
    } catch (e) {
      print(e);
    }
    return removePlayList;
  }

  bool delete_one_file(video videos) {
    try {
      int fIndex = folder_index(videos.parent_folder_id);
      int vIndex = folder_video_index(fIndex, videos.v_id);
      print(fIndex);
      print(vIndex);
      _folder_item[fIndex].f_size -=
          _folder_item[fIndex].f_detail[vIndex].v_size;
      _folder_item[fIndex].f_detail.removeAt(vIndex);
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
    }

    return false;
  }

  video gevideo(String fId, String vId) {
    return _folder_item[folder_index(fId)]
        .f_detail[folder_video_index(folder_index(fId), vId)];
  }

  Map<String, Set<String>> deleteFolder(Set<String> delete) {
    Map<String, Set<String>> removePlayList = {};
    try {
      for (var fId in delete) {
        int fIndex = folder_index(fId);
        if (Storage().deleteFolder(_folder_item[fIndex].f_path)) {
          for (var element in _folder_item[fIndex].f_detail) {
            for (var PId in element.playlist_id) {
              if (removePlayList.containsKey(PId)) {
                removePlayList[PId]!.add(element.v_id);
              } else {
                removePlayList[PId] = Set();
                removePlayList[PId]!.add(element.v_id);
              }
            }
          }
          _folder_item.removeAt(fIndex);
        }
      }
      notifyListeners();

      return removePlayList;
    } catch (e) {}

    return removePlayList;
  }

  Future< bool> rename_folder(String fId, String newftitle) async {
    try {
      int index = folder_index(fId);
      if (Storage().renameFolder(_folder_item[index].f_path, newftitle)) {
        
        String newpath=_folder_item[index]
                .f_path
                .substring(0, _folder_item[index].f_path.lastIndexOf('/'))
                .toString() +
            '/' +
            newftitle;
        //_folder_item[index].f_path = (await Rename_folder_databse(_folder_item[index].f_path,newpath));
        _folder_item[index].f_path = newpath;
        _folder_item[index].f_title = newftitle;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future< bool> rename_file(String vId, String fId, String newvtitle)  async{
    try {
      int fIndex = folder_index(fId);
      int vIndex = folder_video_index(fIndex, vId);

      if (Storage().renamefile(
          _folder_item[fIndex].f_detail[vIndex].v_videoPath, newvtitle)) {
        video v=_folder_item[fIndex].f_detail[vIndex];
        String new_path=v.v_videoPath.substring(
                    0,
                    _folder_item[fIndex]
                            .f_detail[vIndex]
                            .v_videoPath
                            .lastIndexOf('/') +
                        1)
                .toString() +
            newvtitle;
        //_folder_item[fIndex].f_detail[vIndex] = (await rename_file_database(v,new_path,newvtitle));
        //
        _folder_item[fIndex].f_detail[vIndex].v_videoPath = new_path; 
      


        
        notifyListeners();
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  void updatevideoopen(String vId, String fId) async {
    var fIndex = folder_index(fId);
    var vIndex = folder_video_index(fIndex, vId);
    video v = _folder_item[fIndex].f_detail[vIndex];
    v.v_open = true;
    try {
      //_folder_item[fIndex].f_detail[vIndex] = (await update_Video_database(v));
      _folder_item[fIndex].f_detail[vIndex]=v;
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void Setduration(int duration, String vId, String fId) {
    var fIndex = folder_index(fId);
    var vIndex = folder_video_index(fIndex, vId);
    _folder_item[fIndex].f_detail[vIndex].v_duration = duration;

    print("setduration=="+ duration.toString());
    notifyListeners();
  }

  Future<bool> setvideoWatchduration_path(String path, int duration,int total_duration) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setStringList(path, [duration.toString(),total_duration.toString()]);
  }

  void SetWatchedduration(int duration, String vId, String fId) async {
    var fIndex = folder_index(fId);
    var vIndex = folder_video_index(fIndex, vId);
    video v = _folder_item[fIndex].f_detail[vIndex];
    v.v_watched = duration;
    try {
    //  _folder_item[fIndex].f_detail[vIndex] = (await update_Video_database(v));
      if(await setvideoWatchduration_path(v.v_videoPath, duration,v.v_duration)){
        _folder_item[fIndex].f_detail[vIndex]=v;
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  List<video> getsearchvideo(String? filter) {
    List<video> videos = [];
    if (filter == null) return [];

    for (var element in _folder_item) {
      videos.addAll(element.f_detail
          .where((video) =>
              video.v_title.toLowerCase().contains(filter.toLowerCase()))
          .toList());
    }

    return videos;
  }

  String folder_name(String? fId) {
    if (fId == null) return "";
    return _folder_item[folder_index(fId)].f_title;
  }

  List<video> selection_foldervideo(Set<String> selctionList) {
    List<video> selectionVideos = [];
    for (var element in selctionList) {
      selectionVideos.addAll(_folder_item[folder_index(element)].f_detail);
    }
    return selectionVideos;
  }

  List<String> getallvideo_path(Map<String, String> selctionList) {
    List<String> vPath = [];
    try {
      selctionList.forEach((key, element) {
        // print(key.toString()+"  "+element.toString());
        int fIndex = folder_index(element);
        int index = folder_video_index(fIndex, key);
        vPath.add(_folder_item[fIndex].f_detail[index].v_videoPath);
      });
      return vPath;
    } catch (e) {
      print(e);
    }
    return [];
  }

  List<String> get_folder_path(Set<String> selctionList) {
    List<String> folders = [];
    try {
      for (var element in selctionList) {
        folders.add(_folder_item[folder_index(element)].f_path);
      }
    } catch (e) {}

    return folders;
  }

  void add_to_playlist_id(String? pId, List<video> list) {
    try {
      if (pId != null) {
        for (var element in list) {
          int fIndex = folder_index(element.parent_folder_id);
          int vIndex = folder_video_index(fIndex, element.v_id);
          _folder_item[fIndex].f_detail[vIndex].playlist_id.add(pId);
        }
      }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}

class video_details with ChangeNotifier {
  List<video> _video = [];

  List<video> findByName(String title) {
    return _video
        .where((fold) => fold.v_title.contains(title.toLowerCase()))
        .toList();
  }
}

// ignore: camel_case_types
class favourite_details with ChangeNotifier {
  List<favourite> _favourites = [];

  List<favourite> findByAlias(String title) {
    return _favourites
        .where((fav) => fav.v_title.contains(title.toLowerCase()))
        .toList();
  }
}

// class Hide_list_detail extends folder_details {
//   List<Hide_list> _Hide_list_detail = [];
// }

class PlayList_detail with ChangeNotifier {
  // ignore: non_constant_identifier_names

  List<PlayList> _playlist_item = [
    PlayList(p_id: "Favourite", p_title: "Favourite", p_detail: []),
  ];

  fetchdatabase() async {
    try {
      //addin_playlist_database();
      final db = await playerDatabase.instance;
      final List<PlayList> maps = (await db.readAllPlaylist());
      for (var element in maps) {
        int index = _playlist_item
            .indexWhere((playlist) => playlist.p_id == element.p_id);
        if (index == -1) {
          print(element.p_title + "==" + element.count.toString());
          if (element.count <= 0) {
            deleteindatabase(element.p_id);
          } else {
            _playlist_item.add(element);
          }
        }
      }

      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  void addin_playlist_database() {
    try {
      for (var element in _playlist_item) {
        addtodatabase(element);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<PlayList> addtodatabase(PlayList playList) async {
    final db = await playerDatabase.instance;
    playList.count = playList.count + 1;
    return await db.create(playList);
  }

  Future<int> updateindatabase(PlayList playList) async {
    final db = await playerDatabase.instance;
    return await db.update(playList);
  }

  Future<int> deleteindatabase(String pId) async {
    final db = await playerDatabase.instance;
    return await db.delete_playlist(pId);
  }

  List<PlayList> items() {
    return _playlist_item
        .skipWhile((value) => (value.count <= 0 && value.p_id != "Favourite"))
        .toList();
  }

  int getplayList_index_id(String pId) {
    int index = _playlist_item.indexWhere((Playl) => Playl.p_id == pId);
    return index;
  }

  int getplayList_index(String pTitle) {
    int index = _playlist_item.indexWhere((Playl) => Playl.p_title == pTitle);
    return index;
  }

  List<video> getPlayListWithplay_id(String pId) {
    return _playlist_item[getplayList_index_id(pId)].p_detail;
  }

  Future<Map<String, List<video>>?> playlist_adds(List<video> videoDetails,
      String? pTitle, String? pId, Map<String, String> selctionList) async {
    List<video> temp = [];

    String PId = pId != null ? pId : idGenerator();
    int index = pId == null ? -1 : getplayList_index_id(PId);
    try {
      if (index == -1) {
        selctionList.forEach((vId, fId) {
          temp.add(videoDetails[
              videoDetails.indexWhere((video) => video.v_id == vId)]);
        });

        _playlist_item.add(await addtodatabase(PlayList(
            p_id: PId,
            p_title: pTitle != null ? pTitle : "New Playlist",
            p_detail: temp)));
      } else {
        selctionList.forEach((vId, fId) {
          if (_playlist_item[index]
                  .p_detail
                  .indexWhere((element) => element.v_id == vId) ==
              -1) {
            temp.add(videoDetails[
                videoDetails.indexWhere((video) => video.v_id == vId)]);
          }
        });
        PlayList playList = _playlist_item[index];
        playList.p_detail.addAll(temp);
        playList.count = playList.count + temp.length;
        if (updateindatabase(playList) != -1) {
          _playlist_item[index] = playList;
        }
      }

      notifyListeners();

      return {PId: temp};
    } catch (e) {
      print(e);
    }
    return null;
  }

  bool add_one_playlist(String pId, video videoDetail) {
    int index = getplayList_index_id(pId);
    try {
      if (_playlist_item[index]
              .p_detail
              .indexWhere((pv) => pv.v_id == videoDetail.v_id) !=
          -1) {
        PlayList playList = _playlist_item[index];
        playList.p_detail.add(videoDetail);
        playList.count = playList.count + 1;
        if (updateindatabase(playList) != -1) {
          _playlist_item[index] = playList;
        }
      }
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
    }

    return false;
  }

  bool remove_playlist_video(Map<int, String> selctionList) {
    print("hi");
    try {
      {
        selctionList.forEach((key, PId) {
          int index = getplayList_index_id(PId);
          if (index != -1) {
            PlayList playList = _playlist_item[index];
            playList.p_detail.removeWhere((element) => element.v_id == key);
            playList.count = playList.count - 1;

            if (updateindatabase(playList) != -1) {
              _playlist_item[index] = playList;
            }
          }
        });

        notifyListeners();
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  int copy_playList(String pId, String target, List<video> Pvideos) {
    int tindex = getplayList_index_id(pId);
    int c = 0;
    try {
      if (tindex == -1) {
        _playlist_item.add(
            PlayList(p_detail: Pvideos, p_id: idGenerator(), p_title: target));
        c = Pvideos.length;
      } else {
        for (var element in Pvideos) {
          if (_playlist_item[tindex]
                  .p_detail
                  .indexWhere((target) => target.v_id == element.v_id) ==
              -1) {
            _playlist_item[tindex].p_detail.add(element);
            c++;
          }
        }
      }

      notifyListeners();
      return c;
    } catch (e) {
      print(e);
    }
    return -1;
  }

  Future<String?> create_one_copy_playList(
      String title, List<video> passvideo) async {
    try {
      String PId = idGenerator();

      _playlist_item.add(await addtodatabase(
          PlayList(p_detail: passvideo, p_id: PId, p_title: title)));
      notifyListeners();
      return PId;
    } catch (e) {}
    throw (e);

    return null;
  }

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  Future<String?> create_add_one_playlist(String title, video videos) async {
    try {
      String id = idGenerator();
      List<video> passvideo = [videos];
      _playlist_item.add(await addtodatabase(
          PlayList(p_detail: passvideo, p_id: id, p_title: title)));

      notifyListeners();
      return id;
    } catch (e) {}
    return null;
  }

  bool rename_playlist_video(String vId, String pId, String newtitle) {
    try {
      int pindex = getplayList_index_id(pId);

      PlayList playlist = _playlist_item[pindex];
      int pvindex =
          playlist.p_detail.indexWhere((element) => element.v_id == vId);
      if (updateindatabase(playlist) != -1) {
        print("rename  sucess");
        _playlist_item[pindex] = playlist;
      }

      notifyListeners();
      return true;
    } catch (e) {}
    return false;
  }

  bool rename_playlist_folder(String pId, String newtitle) {
    try {
      int pindex = getplayList_index_id(pId);

      if (pindex != -1) {
        PlayList playList = _playlist_item[pindex];
        playList.p_title = newtitle;

        if (updateindatabase(playList) != -1) {
          _playlist_item[pindex] = playList;
        }
        notifyListeners();
        return true;
      }
    } catch (e) {}
    return false;
  }

  bool remove_playlist_folder(Set<String> pId) {
    try {
      for (var pId in pId) {
        if (deleteindatabase(pId) != -1) {
          _playlist_item.removeWhere((element) => element.p_id == pId);
        }
      }
      notifyListeners();
      return true;
    } catch (e) {}
    return false;
  }

  bool Remove_by_v_id(int vId) {
    try {
      bool flag = false;
      for (var ply in _playlist_item) {
        int index = ply.p_detail.indexWhere((element) => element.v_id == vId);
        if (index != -1) {
          ply.p_detail.removeAt(index);
          notifyListeners();
          return true;
        }
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  String? getcurrent_playlist_id(String p_id) {
    return _playlist_item
        .firstWhere((element) => element.p_id == p_id)
        .curr_played_video_id;
  }

  void set_current_playlist(String pId, String vId) {
    int index = getplayList_index_id(pId);
    if (index != -1) {
      _playlist_item[index].curr_played_video_id = vId;
    }
    notifyListeners();
  }

  void reorederd_playlist_video(int oldIndex, int newNdex, String pId) {
    newNdex = newNdex > oldIndex ? newNdex - 1 : newNdex;
    int pIndex = getplayList_index_id(pId);
    video v = _playlist_item[pIndex].p_detail[oldIndex];
    _playlist_item[pIndex].p_detail.removeAt(oldIndex);
    _playlist_item[pIndex].p_detail.insert(newNdex, v);

    updateindatabase(_playlist_item[pIndex]);

    notifyListeners();
  }

  void reorederd_playlist_Folder(int oldIndex, int newNdex) {
    newNdex = newNdex > oldIndex ? newNdex - 1 : newNdex;
    PlayList v = _playlist_item[oldIndex];
    _playlist_item.removeAt(oldIndex);
    _playlist_item.insert(newNdex, v);
    notifyListeners();
  }

  void remove_from_playlist(Map<String, String> map) {
    map.forEach((key, value) {
      int pIndex = getplayList_index_id(key);

      if (pIndex != -1) {
        PlayList playList = _playlist_item[pIndex];

        playList.p_detail.removeWhere((element) => element.v_id == value);
        playList.count = playList.count - 1;
        if (updateindatabase(playList) != -1) {
          _playlist_item[pIndex] = playList;
        }
      }
    });
    notifyListeners();
  }

  playlis_title(String? pId) {
    return _playlist_item.firstWhere((element) => element.p_id == pId).p_title;
  }

  String getplaylisttitle(String pId) {
    return _playlist_item.firstWhere((element) => element.p_id == pId).p_title;
  }

  String P_file_length(String pId) {
    return _playlist_item
        .firstWhere((element) => element.p_id == pId)
        .p_detail
        .length
        .toString();
  }
}

// class queue_playerss with ChangeNotifier{

//   static queue_player? q=null;

// void setvideo_controler(VideoPlayerController controllers){
//   q!.controller=controllers;
//   notifyListeners();
// }

//   void add_video_list_in_queue(int currindex,List<video> videos){
//     //q.controller=controllers;
//     print("ji");
//     q!.curentindex=currindex;
//     q!.queue_video_list=videos;
//     notifyListeners();
//   }

// queue_player? getqueuevideo(){
//   return q;
// }

// String getcurrentvideo(int index){
//   return q!.queue_video_list[index].v_videoPath;
// }
// String getskipnextvideo(int index){
//   if(index>=q!.queue_video_list.length)
//     return "";
//   return q!.queue_video_list[index].v_videoPath;
// }
// String getskipprevvideo(int index){
//   if(index<0)
//     return "";
//   return q!.queue_video_list[index].v_videoPath;
// }

// }

class queue_playerss with ChangeNotifier {
  VideoPlayerController? controller;
  String? f_id = null;
  String? p_id = null;
  static int curentindex = -1;
  List<video> queue_video_list = [];
  static bool b_play = false;

  //  queue_player({
  //   this.controller=null,
  //   required this.curentindex,
  //   required this.queue_video_list,
  //   this.b_play=false,

  // });

  void setvideo_controler(VideoPlayerController controllers) {
    controller = controllers;
    notifyListeners();
  }

  void updatecontoler_play_pause() {
    if (controller!.value.isPlaying) {
      controller!.pause();
    } else {
      controller!.play();
    }
    notifyListeners();
  }

  void add_video_list_in_queue(int currindex, List<video> videos,
      {String? f_id, String? p_id}) {
    curentindex = currindex;
    queue_video_list = videos.toList();
    this.f_id = f_id;
    this.p_id = p_id;

    // videos.forEach((element) => {queue_video_list.add(element)});
    notifyListeners();
  }

  String? getf_id() {
    return f_id;
  }

  String? getp_id() {
    return p_id;
  }

  void add_to_queue(List<video> videos) {
    if (queue_video_list.isEmpty) {
      queue_video_list = videos.toList();
    } else {
      for (var element in videos) {
        if (queue_video_list.indexWhere((v) => v.v_id == element.v_id) == -1) {
          queue_video_list.add(element);
        }
      }
    }
    notifyListeners();
  }

  void play_next_queue(List<video> videos) {
    var oldindex = curentindex;
    if (queue_video_list.isEmpty) {
      queue_video_list = videos.toList();
    } else {
      for (var element in videos) {
        if (queue_video_list.indexWhere((v) => v.v_id == element.v_id) == -1) {
          queue_video_list.insert(++curentindex, element);
        }
      }
    }
    curentindex = oldindex;
    notifyListeners();
  }

  video getvideo_by_id() {
    return queue_video_list[curentindex];
  }

  

  void reorederd_quelist(int oldIndex, int newNdex) {
    newNdex = newNdex > oldIndex ? newNdex - 1 : newNdex;
    video v = queue_video_list[oldIndex];
    queue_video_list.removeAt(oldIndex);
    queue_video_list.insert(newNdex, v);
    curentindex = curentindex == oldIndex
        ? newNdex
        : oldIndex > newNdex
            ? curentindex + 1
            : curentindex - 1;
    notifyListeners();
  }

  List getqueuevideo() {
    return [b_play, controller, curentindex, queue_video_list];
  }

  int getcurrent_index() {
    return curentindex;
  }

  String getcurrentvideo() {
    //print("next_v=="+curentindex.toString()+"  === "+ queue_video_list.length.toString() );
    return queue_video_list[curentindex].v_videoPath;
  }

  String video_title() {
    try {
      return queue_video_list[curentindex].v_title;
    } catch (e) {
      print("error in title");
      print(e);
    }
    return "";
  }

  void updateindex(bool prev) {
    curentindex = prev == true ? curentindex - 1 : curentindex + 1;
    print("b_play==" + curentindex.toString());
    notifyListeners();
  }

  void remove_from_queue(String vId) {
    try {
      var qIndex =
          queue_video_list.indexWhere((element) => element.v_id == vId);
      queue_video_list.removeAt(qIndex);
      if (queue_video_list.length > 0 &&
          (qIndex == curentindex || curentindex >= queue_video_list.length)) {
        curentindex = Random().nextInt(queue_video_list.length);
      }

      if (queue_video_list.length == 0) {
        curentindex = -1;
      }
      print(curentindex);

      notifyListeners();
    } catch (e) {
      print("error are remove ");
      print(e);
    }
  }

  void clear_queue() {
    queue_video_list.clear();
    curentindex = -1;
    notifyListeners();
  }

  void update_play_pause() {
    b_play = !b_play;
    notifyListeners();
  }

  bool getplay_pause() {
    return b_play;
  }

bool get_random_video() {
    if (queue_video_list.length > 0) {
      curentindex = Random().nextInt(queue_video_list.length);
      notifyListeners();
      return true;
    }
    return false;
  }

bool get_rotate_video() {
    if (queue_video_list.length > 0) {
      curentindex = (curentindex + 1) % queue_video_list.length;
      notifyListeners();
      return true;
    }
    return false;
  }


  bool getskipnextvideo() {
    if (curentindex + 1 >= queue_video_list.length) {
      return false;
    }
    updateindex(false);
    return true;
  }

  bool getskipprevvideo() {
    if (curentindex - 1 < 0) {
      return false;
    }

    updateindex(true);
    return true;
  }

  void togle_bacground_play() {
    b_play = !b_play;

    notifyListeners();
  }

  bool set_current_index(int index) {
    try {
      if (index >= 0 && index < queue_video_list.length) {
        curentindex = index;
      } else {
        return false;
      }
      notifyListeners();
      return true;
    } catch (e) {}
    return false;
  }
}

class recent_videos with ChangeNotifier {
  List<recent_video> recent_video_list = [];

  void fetchrecent_video() async {
    final db = await playerDatabase.instance;
    var maps = (await db.readAllRecent());
    recent_video_list = maps;
    notifyListeners();
  }

  Future<recent_video> add_to_database(recent_video v) async {
    final db = await playerDatabase.instance;
    print(v.R_video_id);

    return await db.insert_recent_video(v);
  }

  Future<List<recent_video>> get_recent_video() async {
    final db = await playerDatabase.instance;
    return await db.readAllRecent();
  }

  Future<int> delete_recent_video(String r_id) async {
    final db = await playerDatabase.instance;
    return await db.delete_recent_video(r_id);
  }

  Future<int> delete_all_recent_video() async {
    final db = await playerDatabase.instance;
    return await db.delete_all_recent_video();
  }

  Future<int> update_recent_video(recent_video v) async {
    final db = await playerDatabase.instance;
    return await db.update_recent_video(v);
  }

  Future<dynamic> Find_recent_video(String r_id) async {
    final db = await playerDatabase.instance;
    return await db.readRecent(r_id);
  }

  void add_to_recent(video v) async {
    try {
      recent_video r = recent_video(
          R_video_id: v.v_id,
          time_stamp: DateTime.now().microsecondsSinceEpoch,
          videos: v);

      int r_index = recent_video_list
          .indexWhere((element) => element.R_video_id == v.v_id);
      if (r_index != -1) {
        if (update_recent_video(r) != -1) {
          recent_video_list.removeAt(r_index);
          recent_video_list.insert(0, r);
        }
      } else {
        if (recent_video_list.length >= 31) {
          recent_video_list.removeAt(31);
        }
        add_to_database(r);
        recent_video_list.insert(0, r);
      }
      notifyListeners();
      return;
    } catch (e) {
      print(e);
    }
  }

  void remove_from_recent(List<String> delete) async {
    try {
      //print(delete);
      delete.forEach((vId) {
        if (delete_recent_video(vId) != -1) {
          recent_video_list.removeWhere((element) => element.R_video_id == vId);
        }
      });
      notifyListeners();
      return;
    } catch (e) {
      print(e);
    }
  }

  void remove_all_recent() async {
    if (delete_all_recent_video() != -1) {
      recent_video_list.clear();
      notifyListeners();
    }
  }

// List<recent_video> getrecent_videot(){
//     return recent_video_list;
// }

  int getRecentvideo_size() {
    int size = 0;
    recent_video_list.forEach((element) {
      size += element.videos.v_size;
    });
    return size;
  }

  List<video> getrecent_video_list() {
    List<video> v = [];
    recent_video_list.forEach((element) {
      v.add(element.videos);
    });
    return v;
  }

  bool showReecent() {
    return recent_video_list.length > 0;
  }
}
