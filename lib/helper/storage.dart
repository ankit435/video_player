import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:video/helper/file.dart';
import 'package:video_player/video_player.dart';

class Storage {
  static Set<String>ext={'MP4','FLV','MOV','MKV','AVI','WMV'};
   int v_id=0;
   int f_id=0;
  Future<File> changeFileNameOnly(File file, String newFileName) {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return file.rename(newPath);
  }
  String folder_name(String path) {
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(lastSeparator + 1);
    return newPath == '' ? "Internal Storage" : newPath;
  }
  bool check(String s) {
    return !folder_name(s).startsWith(RegExp(r"\.[\w]+"));
  }
static String getFileExtensions(FileSystemEntity file) {
    if (file is File) {
      return file.path.split("/").last.split('.').last;
    } else {
      throw "FileSystemEntity is Directory, not a File";
    }
  }

  getFileSize(int bytes, int decimals)  {
   
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }
  static bool filterExtension(String extension){
    
    return ext.contains(extension.toUpperCase());
  }
String getFileExtension(String fileName) {
try {
  return "." + fileName.split('.').last;
 } catch(e){
  return e.toString();
 }
}
  void getfolder(List root, List<folder> folders, String parent,dynamic size,int t_id,int z_id) {
    List<video> file = [];
    
    for (var i in root) {
     // if (check(i.absolute.path)) 
      {
        if (i is Directory) {
          getfolder(Directory(i.path).listSync(recursive: false), folders,
              i.absolute.path,0,t_id++,0);
        } else {
          // file.add(i.absolute.path);
          if(filterExtension(getFileExtensions(i))){
          size+=i.lengthSync();
          file.add(video(
              parent_folder_id: f_id,
              v_id: v_id++,
              v_title: folder_name(i.absolute.path),
              v_thumbnailPath: i.absolute.path,
              v_videoPath: i.path,
              v_duration: -1,
              v_timestamp: i.lastModifiedSync(),
              v_watched: 0,
              v_size: i.lengthSync(),
              v_lastmodified: i.lastModifiedSync(),
              ),
              );
          }
        }
      }
    }
   
    if (file.isNotEmpty) {
      // print("f_id == "+f_id.toString()+"  ,  v_id== "+v_id.toString()+" , file len == "+file.length.toString());
      folder newfolder = folder(
          f_id: f_id++,
          f_title: folder_name(parent),
          f_path: parent,
          f_detail: file,
          f_timestamp: DateTime.now(), 
          f_size: size);
      folders.add(newfolder);
      
    }
  }


  Future<List<folder>> localPath() async {
    List root = Directory("/storage/emulated/0/").listSync(recursive: false);
    root.removeAt(0);
    List<folder> _folders = [];
    getfolder(root, _folders, "/storage/emulated/0/",0,0,0);
    return _folders;
  }


  bool File_deletes(Set<int> selctionList, List<video> filePath) {

      try {
        selctionList.forEach((element) { 
            File(filePath[element].v_videoPath).deleteSync(recursive: false);
        ;});
        return true;
      } catch (e) {
        print(e);
       
      }

    return false;
  }
  //   bool Folder_deletes(Set<int> selctionList, List<video> Folder_path) {

  //     try {
  //       selctionList.forEach((element) { 
  //           Directory(Folder_path[element].f_path).deleteSync(recursive: true);
  //       ;});
  //       return true;
  //     } catch (e) {
  //       print(e);
  //       return false;
  //     }

  //   return false;
  // }
}



