import 'package:flutter/cupertino.dart';
import 'package:video/Playlist/playlist_file.dart';
import 'package:video/helper/file.dart';

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

  List<folder> items()  {
    return _folder_item;
  }

  List<video> getAllvideo() {
    List<video> videos = [];
    _folder_item.forEach((element) {
      videos.addAll(element.f_detail);
    });

    return videos;
  }

  int folder_index(int fId) {
    int index = _folder_item.indexWhere((element) => element.f_id == fId);
    return index;
  }

List< video> getfolderIdvideo(int f_id){
  return _folder_item[folder_index(f_id)].f_detail;
}
  int folder_video_index(int f_index, int v_id) {
    int index = _folder_item[f_index]
        .f_detail
        .indexWhere((video) => video.v_id == v_id);
    return index;
  }

  int gettotalvideosize() {
    int size = 0;
    _folder_item.forEach((element) {
      size += element.f_size;
    });

    return size;
  }

  int gefoldersize(int fId) {
    return _folder_item[folder_index(fId)].f_size;
  }

  Future<List<String>>? getfoldername() async {
    List<String> temp = [];
    _folder_item.forEach((element) {
      temp.add(element.f_title);
    });
    return temp;
  }

  List<video> getfoldertotalvideo(int f_id, String sort, bool sortrevrsed) {
    if(sort=='Name'){
    _folder_item[folder_index(f_id)].f_detail.sort((a, b) {return a.v_title.toLowerCase().compareTo(b.v_title.toLowerCase());} );
    }
    else if(sort=="Date"){
        _folder_item[folder_index(f_id)].f_detail.sort((a, b) {return a.v_timestamp .compareTo(b.v_timestamp);} );
    }
    else if(sort=="Length"){
        _folder_item[folder_index(f_id)].f_detail.sort((a, b) {return a.v_duration.compareTo(b.v_duration);} );
    }
    else if(sort=="Size"){
        _folder_item[folder_index(f_id)].f_detail.sort((a, b) {return a.v_size.compareTo(b.v_size);} );
    }

    if(sortrevrsed){
      return _folder_item[folder_index(f_id)].f_detail.reversed.toList();
    }
    return _folder_item[folder_index(f_id)].f_detail;
  }

  Future<bool> delete_file(Map<int, int> selctionList) async {
    try {
      selctionList.forEach((key, element) {
        // print(key.toString()+"  "+element.toString());
        int fIndex = folder_index(element);
        int index = folder_video_index(fIndex, key);

        // print(fIndex.toString()+"  "+index.toString());
        _folder_item[fIndex].f_size = (_folder_item[fIndex].f_size) -
            (_folder_item[fIndex].f_detail[index].v_size);
        _folder_item[fIndex].f_detail.removeAt(index);
      });
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  bool delete_one_file(video videos) {
    try {
      int f_index=folder_index(videos.parent_folder_id);
      int v_index=folder_video_index(f_index,videos.v_id);
      print(f_index);
      print(v_index);
      _folder_item[f_index].f_size-=_folder_item[f_index].f_detail[v_index].v_size;
      _folder_item[f_index].f_detail.removeAt(v_index);
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
    }

    return false;
  }

  video getvideo(int f_id, int v_id) {
    //  print(f_id);print(v_id);

    return _folder_item[f_id].f_detail[v_id];
  }

  bool deleteFolder(int f_id) {

    try {
      _folder_item.removeAt(folder_index(f_id));
      notifyListeners();
      return true;
    } catch (e) {
      
    }

      return false;
  }

  bool rename_folder(int f_id,String newftitle){
    try {
       int index=folder_index(f_id);
      _folder_item[index].f_title=newftitle;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }
  bool rename_file(int v_id,int f_id,String newvtitle){
  try {
    int f_index=folder_index(f_id);
      _folder_item[f_index].f_detail[folder_video_index(f_index,v_id)].v_title=newvtitle;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

void updatevideoopen(int v_id,int f_id){

  var f_index=folder_index(f_id);
  var v_index=folder_video_index(f_index, v_id);
  _folder_item[f_index].f_detail[v_index].v_open=true;
  notifyListeners();
  
}

  void Setduration(int duration,int v_id,int f_id) {
  var f_index=folder_index(f_id);
  var v_index=folder_video_index(f_index, v_id);
  _folder_item[f_index].f_detail[v_index].v_duration=duration;
  notifyListeners();
  }

  void SetWatchedduration(int duration, int v_id, int f_id) {
      var f_index=folder_index(f_id);
  var v_index=folder_video_index(f_index, v_id);
  print("duration"+duration.toString());
  _folder_item[f_index].f_detail[v_index].v_watched=duration;
  notifyListeners();
  }

 Future< List<video>>? getsearchvideo(String? filter) async {

  List<video> ?videos=[];
 

    _folder_item.forEach((element) { 
        videos.addAll(element.f_detail.where((video) => video.v_title.toLowerCase().contains(filter!.toLowerCase())).toList());
    });

    return videos;
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

class Hide_list_detail with ChangeNotifier {
  List<Hide_list> _Hide_list_detail = [];
}

class PlayList_detail with ChangeNotifier {
  // ignore: non_constant_identifier_names
  List<PlayList> _playlist_item = [
    PlayList(p_id: 0, p_title: "Favourite", p_detail: []),
  ];

  List<PlayList> items() {
    return _playlist_item;
  }

int getplayList_id(int p_id) {
    int index = _playlist_item.indexWhere((Playl) => Playl.p_id == p_id);
    return index;
  }

  int getplayList_index(String pTitle) {
    int index = _playlist_item.indexWhere((Playl) => Playl.p_title == pTitle);
    return index;
  }

  List<video> getPlayListWithplay_id(int p_id) {
    return _playlist_item[getplayList_id(p_id)].p_detail;
  }

  bool add_to_palylist(video v, String pTitle) {
    try {
      int index = getplayList_index(pTitle);
      _playlist_item[index].p_detail.add(v);
      notifyListeners();
      return true;
    } catch (e) {}
    return false;
  }

  bool playlist_adds(
      List<video> video_details, String pTitle, Map<int, int> selctionList) {
    try {
      List<video> temp = [];
      int index = getplayList_index(pTitle);

      selctionList.forEach((key, value) {
        int v_index =
            video_details.indexWhere((element) => element.v_id == key);

        if (index == -1) {
          temp.add(video_details[v_index]);
        } else {
          if (_playlist_item[index]
                  .p_detail
                  .indexWhere((pv) => pv.v_id == key) ==
              -1) {
            _playlist_item[index].p_detail.add(video_details[v_index]);
          }
        }
      });

      if (index == -1) {
        _playlist_item.add(PlayList(
            p_id: _playlist_item.length + 1, p_title: pTitle, p_detail: temp));
      }
      notifyListeners();
      return true;
    } catch (e) {}
    return false;
  }

  bool add_one_playlist(int p_id, video video_detail) {
    int index = getplayList_id(p_id);
    try {
        if (_playlist_item[index]
                .p_detail
                .indexWhere((pv) => pv.v_id == video_detail.v_id) ==
            -1)
             {
          _playlist_item[index].p_detail.add(video_detail);
          }
      
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
    }

    return false;
  }

bool remove_playlist_video(int p_id, int v_id) {
int index = getplayList_id(p_id);
    try {
     
      {
        int p_video_index =
            _playlist_item[index].p_detail.indexWhere((pv) => pv.v_id == v_id);
        if (p_video_index != -1) {
          _playlist_item[index].p_detail.removeAt(p_video_index);
        }
      }
      
      
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  int copy_playList(int p_id,String target, List<video> Pvideos) {


    int tindex =
        _playlist_item.indexWhere((element) => element.p_id == p_id);
    int c = 0;
    try {
      if (tindex == -1) {
        _playlist_item.add(PlayList(
            p_detail: Pvideos,
            p_id: _playlist_item.length+1,
            p_title: target));
        c = Pvideos.length;
      } else 
      {
        Pvideos.forEach((element) {
          if (_playlist_item[tindex]
                  .p_detail
                  .indexWhere((target) => target.v_id == element.v_id) ==
              -1) {
            _playlist_item[tindex].p_detail.add(element);
            c++;
          }
        });
      }

      notifyListeners();
      return c;
    } catch (e) {
      print(e);
    }
    return -1;
  }

  bool create_one_copy_playList(String title,List<video> passvideo) {

    try {
      _playlist_item.add(PlayList(p_detail: passvideo,p_id: _playlist_item.length+1,p_title: title));
      notifyListeners();
      return true;
    } catch (e) {
      
    }
    return false;
  }

  bool create_add_one_playlist(String title, video videos) {
     try {
       List<video> passvideo=[videos];
      _playlist_item.add(PlayList(p_detail: passvideo,p_id: _playlist_item.length+1,p_title: title));
      notifyListeners();
      return true;
    } catch (e) {
      
    }
    return false;
  }


bool rename_playlist_video(int v_id,int p_id,String newtitle){

  try {
    int pindex=getplayList_id(p_id);
    int pvindex=_playlist_item[pindex].p_detail.indexWhere((element) => element.v_id==v_id);
    _playlist_item[pindex].p_detail[pvindex].v_title=newtitle;
    notifyListeners();
    return true;
  } catch (e) {
    
  }
  return false;
}
bool rename_playlist_folder(int p_id,String newtitle){

  try {
    int pindex=getplayList_id(p_id);
     _playlist_item[pindex].p_title=newtitle;
    notifyListeners();
    return true;
  } catch (e) {
    
  }
  return false;
}

  bool remove_playlist_folder(int p_id) {

      try {
        _playlist_item.removeWhere((element) => element.p_id==p_id);
        notifyListeners();
        return true;
      } catch (e) {
        
      }
      return false;

  }

  bool Remove_by_v_id(int v_id) {
    try {
      bool flag=false;
      for(var ply in _playlist_item){
        int index=ply.p_detail.indexWhere((element) => element.v_id==v_id);
        if(index!=-1)
        {
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


}