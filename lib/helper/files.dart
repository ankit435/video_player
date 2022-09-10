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
          secondaryHeaderColor: Color.fromARGB(255, 6, 235, 124),
          brightness: Brightness.light,
          backgroundColor: Color.fromARGB(255, 40, 23, 75),
          accentColor: Colors.black,
          primaryIconTheme:
              IconThemeData(color: Color.fromARGB(255, 15, 107, 206)),
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

  Future<void> addfolder(List<folder> newfolader) async {
    try {
      _folder_item = newfolader;
    } catch (error) {
      print(error);
      throw error;
    }
    notifyListeners();
  }

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

  List<video> getfolderIdvideo(String f_id) {
    return _folder_item[folder_index(f_id)].f_detail;
  }

  int folder_video_index(int f_index, String v_id) {
    int index = _folder_item[f_index]
        .f_detail
        .indexWhere((video) => video.v_id == v_id);
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

  String getfoldername(String f_id) {
    return _folder_item[folder_index(f_id)].f_title;
  }


  // void thumbailedatabase(String f_id, String v_id, String thumail) async{
  //   final db = await playerDatabase.instance;
  //       // db.create_thumbaile(v_id, thumail,duration: f_id);
  // }


String ?getthumbailpath(String f_id,String v_id){

  int f_index=folder_index(f_id);
  int v_index=folder_video_index(f_index, v_id);

  return _folder_item[f_index].f_detail[v_index].v_thumbnailPath;
}

  bool setthumail(String f_id, String v_id, String thumail) {
   
    try {
        //  thumbailedatabase(f_id, v_id, thumail);
         _folder_item[folder_index(f_id)]
            .f_detail[folder_video_index(folder_index(f_id), v_id)]
            .v_thumbnailPath = thumail;
        notifyListeners();
        return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  List<video> getfoldertotalvideo(String f_id, String sort, bool sortrevrsed) {
    if (sort == 'Name') {
      _folder_item[folder_index(f_id)].f_detail.sort((a, b) {
        return a.v_title.toLowerCase().compareTo(b.v_title.toLowerCase());
      });
    } else if (sort == "Date") {
      _folder_item[folder_index(f_id)].f_detail.sort((a, b) {
        return a.v_timestamp.compareTo(b.v_timestamp);
      });
    } else if (sort == "Length") {
      _folder_item[folder_index(f_id)].f_detail.sort((a, b) {
        return a.v_duration.compareTo(b.v_duration);
      });
    } else if (sort == "Size") {
      _folder_item[folder_index(f_id)].f_detail.sort((a, b) {
        return a.v_size.compareTo(b.v_size);
      });
    }

    if (sortrevrsed) {
      return _folder_item[folder_index(f_id)].f_detail.reversed.toList();
    }
    return _folder_item[folder_index(f_id)].f_detail;
  }

  Map<String, Set<String>> delete_file(Map<String, String> selctionList) {
    Map<String, Set<String>> remove_play_list = {};
    try {
      selctionList.forEach((v_id, f_id) {
        int fIndex = folder_index(f_id);
        int index = folder_video_index(fIndex, v_id);

        if (Storage()
            .deleteFile(_folder_item[fIndex].f_detail[index].v_videoPath)) {
          _folder_item[fIndex].f_size = (_folder_item[fIndex].f_size) -
              (_folder_item[fIndex].f_detail[index].v_size);

          for (var P_id in _folder_item[fIndex].f_detail[index].playlist_id) {
            if (remove_play_list.containsKey(P_id)) {
              remove_play_list[P_id]!.add(v_id);
            } else {
              remove_play_list[P_id] = Set();
              remove_play_list[P_id]!.add(v_id);
            }
          }
          _folder_item[fIndex].f_detail.removeAt(index);
        }
      });
      notifyListeners();

      return remove_play_list;
    } catch (e) {
      print(e);
    }
    return remove_play_list;
  }

  bool delete_one_file(video videos) {
    try {
      int f_index = folder_index(videos.parent_folder_id);
      int v_index = folder_video_index(f_index, videos.v_id);
      print(f_index);
      print(v_index);
      _folder_item[f_index].f_size -=
          _folder_item[f_index].f_detail[v_index].v_size;
      _folder_item[f_index].f_detail.removeAt(v_index);
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
    }

    return false;
  }

  video gevideo(String f_id, String v_id) {
    return _folder_item[folder_index(f_id)]
        .f_detail[folder_video_index(folder_index(f_id), v_id)];
  }

  Map<String, Set<String>> deleteFolder(Set<String> delete) {
    Map<String, Set<String>> remove_play_list = {};
    try {
      for (var f_id in delete) {
        int f_index = folder_index(f_id);
        if (Storage().deleteFolder(_folder_item[f_index].f_path)) {
          for (var element in _folder_item[f_index].f_detail) {
            for (var P_id in element.playlist_id) {
              if (remove_play_list.containsKey(P_id)) {
                remove_play_list[P_id]!.add(element.v_id);
              } else {
                remove_play_list[P_id] = Set();
                remove_play_list[P_id]!.add(element.v_id);
              }
            }
          }
          _folder_item.removeAt(f_index);
        }
      }
      notifyListeners();

      return remove_play_list;
    } catch (e) {}

    return remove_play_list;
  }

  bool rename_folder(String f_id, String newftitle) {
    try {
      int index = folder_index(f_id);
      if (Storage().renameFolder(_folder_item[index].f_path, newftitle)) {
        _folder_item[index].f_title = newftitle;
        _folder_item[index].f_path = _folder_item[index]
                .f_path
                .substring(0, _folder_item[index].f_path.lastIndexOf('/'))
                .toString() +
            '/' +
            newftitle;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  bool rename_file(String v_id, String f_id, String newvtitle) {
    try {
      int f_index = folder_index(f_id);
      int v_index = folder_video_index(f_index, v_id);

      if (Storage().renamefile(
          _folder_item[f_index].f_detail[v_index].v_videoPath, newvtitle)) {
        _folder_item[f_index].f_detail[v_index].v_title = newvtitle;
        _folder_item[f_index].f_detail[v_index].v_videoPath =
            _folder_item[f_index]
                    .f_detail[v_index]
                    .v_videoPath
                    .substring(
                        0,
                        _folder_item[f_index]
                                .f_detail[v_index]
                                .v_videoPath
                                .lastIndexOf('/') +
                            1)
                    .toString() +
                newvtitle;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  void updatevideoopen(String v_id, String f_id) {
    var f_index = folder_index(f_id);
    var v_index = folder_video_index(f_index, v_id);
    _folder_item[f_index].f_detail[v_index].v_open = true;
    notifyListeners();
  }

  void Setduration(int duration, String v_id, String f_id) {
    var f_index = folder_index(f_id);
    var v_index = folder_video_index(f_index, v_id);
    _folder_item[f_index].f_detail[v_index].v_duration = duration;
    notifyListeners();
  }

  void setvideoWatchduration( String path,int duration) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(path, duration);
  }


  void SetWatchedduration(int duration, String v_id, String f_id) {
    var f_index = folder_index(f_id);
    var v_index = folder_video_index(f_index, v_id);
    print("duration" + duration.toString());
    //setvideoWatchduration(_folder_item[f_index].f_detail[v_index].v_videoPath,duration);
    _folder_item[f_index].f_detail[v_index].v_watched = duration;
    notifyListeners();
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

  String folder_name(String? f_id) {
    if (f_id == null) return "";
    return _folder_item[folder_index(f_id)].f_title;
  }

  List<video> selection_foldervideo(Set<String> selction_list) {
    List<video> selection_videos = [];
    for (var element in selction_list) {
      selection_videos.addAll(_folder_item[folder_index(element)].f_detail);
    }
    return selection_videos;
  }

  List<String> getallvideo_path(Map<String, String> selction_list) {
    List<String> v_path = [];
    try {
      selction_list.forEach((key, element) {
        // print(key.toString()+"  "+element.toString());
        int fIndex = folder_index(element);
        int index = folder_video_index(fIndex, key);
        v_path.add(_folder_item[fIndex].f_detail[index].v_videoPath);
      });
      return v_path;
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

  void add_to_playlist_id(String? p_id, List<video> list) {
    try {
      if (p_id != null) {
        for (var element in list) {
          int f_index = folder_index(element.parent_folder_id);
          int v_index = folder_video_index(f_index, element.v_id);
          _folder_item[f_index].f_detail[v_index].playlist_id.add(p_id);
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

class Hide_list_detail extends folder_details {
  List<Hide_list> _Hide_list_detail = [];
}

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

  Future<int> deleteindatabase(String p_id) async {
    final db = await playerDatabase.instance;
    return await db.delete_playlist(p_id);
  }

  List<PlayList> items() {
    return _playlist_item
        .skipWhile((value) => (value.count <= 0 && value.p_id != "Favourite"))
        .toList();
  }

  int getplayList_index_id(String p_id) {
    int index = _playlist_item.indexWhere((Playl) => Playl.p_id == p_id);
    return index;
  }

  int getplayList_index(String pTitle) {
    int index = _playlist_item.indexWhere((Playl) => Playl.p_title == pTitle);
    return index;
  }

  List<video> getPlayListWithplay_id(String p_id) {
    return _playlist_item[getplayList_index_id(p_id)].p_detail;
  }

  Future<Map<String, List<video>>?> playlist_adds(List<video> video_details,
      String? pTitle, String? p_id, Map<String, String> selctionList) async {
    List<video> temp = [];

    String P_id = p_id != null ? p_id : idGenerator();
    int index = p_id == null ? -1 : getplayList_index_id(P_id);
    try {
      if (index == -1) {
        selctionList.forEach((v_id, f_id) {
          temp.add(video_details[
              video_details.indexWhere((video) => video.v_id == v_id)]);
        });

        _playlist_item.add(await addtodatabase(PlayList(
            p_id: P_id,
            p_title: pTitle != null ? pTitle : "New Playlist",
            p_detail: temp)));
      } else {
        selctionList.forEach((v_id, f_id) {
          if (_playlist_item[index]
                  .p_detail
                  .indexWhere((element) => element.v_id == v_id) ==
              -1) {
            temp.add(video_details[
                video_details.indexWhere((video) => video.v_id == v_id)]);
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

      return {P_id: temp};
    } catch (e) {
      print(e);
    }
    return null;
  }

  bool add_one_playlist(String p_id, video video_detail) {
    int index = getplayList_index_id(p_id);
    try {
      if (_playlist_item[index]
              .p_detail
              .indexWhere((pv) => pv.v_id == video_detail.v_id) !=
          -1) {
        PlayList playList = _playlist_item[index];
        playList.p_detail.add(video_detail);
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
        selctionList.forEach((key, P_id) {
          int index = getplayList_index_id(P_id);
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

  int copy_playList(String p_id, String target, List<video> Pvideos) {
    int tindex = getplayList_index_id(p_id);
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
      String P_id = idGenerator();

      _playlist_item.add(await addtodatabase(
          PlayList(p_detail: passvideo, p_id: P_id, p_title: title)));
      notifyListeners();
      return P_id;
    } catch (e) {}
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

  bool rename_playlist_video(String v_id, String p_id, String newtitle) {
    try {
      int pindex = getplayList_index_id(p_id);
      int pvindex = _playlist_item[pindex]
          .p_detail
          .indexWhere((element) => element.v_id == v_id);
      _playlist_item[pindex].p_detail[pvindex].v_title = newtitle;
      notifyListeners();
      return true;
    } catch (e) {}
    return false;
  }

  bool rename_playlist_folder(String p_id, String newtitle) {
    try {
      int pindex = getplayList_index_id(p_id);

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

  bool remove_playlist_folder(Set<String> p_id) {
    try {
      for (var p_id in p_id) {
        if (deleteindatabase(p_id) != -1) {
          _playlist_item.removeWhere((element) => element.p_id == p_id);
        }
      }
      notifyListeners();
      return true;
    } catch (e) {}
    return false;
  }

  bool Remove_by_v_id(int v_id) {
    try {
      bool flag = false;
      for (var ply in _playlist_item) {
        int index = ply.p_detail.indexWhere((element) => element.v_id == v_id);
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

  void reorederd_playlist_video(int old_index, int new_ndex, String p_id) {
    new_ndex = new_ndex > old_index ? new_ndex - 1 : new_ndex;
    int p_index = getplayList_index_id(p_id);
    video v = _playlist_item[p_index].p_detail[old_index];
    _playlist_item[p_index].p_detail.removeAt(old_index);
    _playlist_item[p_index].p_detail.insert(new_ndex, v);
    notifyListeners();
  }

  void reorederd_playlist_Folder(int old_index, int new_ndex) {
    new_ndex = new_ndex > old_index ? new_ndex - 1 : new_ndex;
    PlayList v = _playlist_item[old_index];
    _playlist_item.removeAt(old_index);
    _playlist_item.insert(new_ndex, v);
    notifyListeners();
  }

  void remove_from_playlist(Map<String, String> map) {
    map.forEach((key, value) {
      int p_index = getplayList_index_id(key);

      if (p_index != -1) {
        PlayList playList = _playlist_item[p_index];

        playList.p_detail.removeWhere((element) => element.v_id == value);
        playList.count = playList.count - 1;
        if (updateindatabase(playList) != -1) {
          _playlist_item[p_index] = playList;
        }
      }
    });
    notifyListeners();
  }

  playlis_title(String? p_id) {
    return _playlist_item.firstWhere((element) => element.p_id == p_id).p_title;
  }

  String getplaylisttitle(String p_id) {
    return _playlist_item.firstWhere((element) => element.p_id == p_id).p_title;
  }

  String P_file_length(String p_id) {
    return _playlist_item
        .firstWhere((element) => element.p_id == p_id)
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

  void reorederd_quelist(int old_index, int new_ndex) {
    new_ndex = new_ndex > old_index ? new_ndex - 1 : new_ndex;
    video v = queue_video_list[old_index];
    queue_video_list.removeAt(old_index);
    queue_video_list.insert(new_ndex, v);
    curentindex = curentindex == old_index
        ? new_ndex
        : old_index > new_ndex
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

  void remove_from_queue(String v_id) {
    try {
      var q_index =
          queue_video_list.indexWhere((element) => element.v_id == v_id);
      queue_video_list.removeAt(q_index);
      if (queue_video_list.length > 0 &&
          (q_index == curentindex || curentindex >= queue_video_list.length)) {
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
