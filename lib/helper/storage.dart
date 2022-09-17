import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:video/helper/file.dart';
import 'package:video_player/video_player.dart';
import 'neo_player/player.dart';

class Storage {
  static Set<String> ext = {'MP4', 'FLV', 'MOV', 'MKV', 'AVI', 'WMV'};

  int v_id = 0;
  int f_id = 0;
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

  static bool isVideo(FileSystemEntity file) {
    if (file is File) {
      return ext.contains(getFileExtensions(file).toUpperCase());
    } else {
      throw "FileSystemEntity is Directory, not a File";
    }
  }

  Future<Directory> video_thumbail() async {
    //var dir = await getExternalStorageDirectory();
    //var path = dir?.path;
    var directory = Directory("/storage/emulated/0/neo_player/");
    if (!await directory.exists()) {
      await directory.create();
    }
    return directory;
  }

// Future<String?> Createvideothumbail(File path) async{
//   var dir = await video_thumbail();
//   var thumbnail = await VideoThumbnail.thumbnailFile(
//     video: path.path,
//     thumbnailPath: dir.path,
//     imageFormat: ImageFormat.JPEG,
//     maxHeight: 128, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
//     quality: 7,
//   );
//   print(thumbnail.toString());
//   return thumbnail;

// }

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  getFileSize(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
  }

  static bool filterExtension(String extension) {
    return ext.contains(extension.toUpperCase());
  }

  String getFileExtension(String fileName) {
    try {
      return "." + fileName.split('.').last;
    } catch (e) {
      return e.toString();
    }
  }

  // Future<int> getVideowatchduration( String path) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int? v_id = prefs.getInt(path);
  //   if(v_id ==null)
  //   {
  //     await prefs.setInt(path, 0);
  //     return 0;
  //   }
  //   return v_id;
  // }
  
  

      String get_thumbail_path(String path){
      String filename = folder_name(path);
      var lastSeparator = filename.lastIndexOf('.');
      var newPath = filename.substring(0, lastSeparator);
     return  "/storage/emulated/0/neo_player/$newPath.jpg";
}



  String? gethumbail(String path) {
    // String filename = folder_name(path);
    // var lastSeparator = filename.lastIndexOf('.');
    // var newPath = filename.substring(0, lastSeparator);
    String thumbailpath =get_thumbail_path(path);

    if (File(thumbailpath).existsSync()) {
      return thumbailpath;
    }
    // print("null");
    return null;
  }

  // void setvideoWatchduration(String path, int duration) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setInt(path, duration);
  // }

  Future<List<String>> getVideowatchduration(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? v_id = prefs.getStringList(path);

   
    if (v_id == null) {
    //  await prefs.setStringList(path, ['0','-1']);
      return ['0','-1'];
    }
    return v_id;
  }

  

  void getfolder(List root, List<folder> folders, String parent, dynamic size,
      int t_id, int z_id) async {
    List<video> file = [];
    String f_id = parent;

    for (var i in root) {
      // if (check(i.absolute.path))
      {
        if (i is Directory) {
          getfolder(Directory(i.path).listSync(recursive: false), folders,
              i.absolute.path, 0, t_id++, 0);
        } else {
          // file.add(i.absolute.path);
          if (filterExtension(getFileExtensions(i))) {
            size += i.lengthSync();
            //Future<String?> thum= Createvideothumbail(i);
             List<String> watched=await getVideowatchduration(i.absolute.path);
            file.add(
             
              video(
                parent_folder_id: f_id,
                v_id: i.absolute.path,
                v_title: folder_name(i.absolute.path),
                v_thumbnailPath: gethumbail(i.absolute.path),
                v_videoPath: i.path,
                v_duration: int.parse(watched[1]),
                v_timestamp: i.lastModifiedSync(),
                v_watched: int.parse(watched[0]),
                v_size: i.lengthSync(),
                v_lastmodified: i.lastModifiedSync(),
                ListedTime: DateTime.now(),
                v_favourite: false,
                v_open: watched[1]=='-1'?false:true,
                playlist_id: {},
              ),
            );
          }
        }
      }
    }

    if (file.isNotEmpty) {
      // print("f_id == "+f_id.toString()+"  ,  v_id== "+v_id.toString()+" , file len == "+file.length.toString());
      folder newfolder = folder(
          f_id: f_id,
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
    getfolder(root, _folders, "/storage/emulated/0/", 0, 0, 0);
    return _folders;
  }

  void videuration_delete(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(path);
  }

  bool File_deletes(Set<int> selctionList, List<video> filePath) {
    try {
      selctionList.forEach((element) {
        File(filePath[element].v_videoPath).deleteSync(recursive: false);
        videuration_delete(filePath[element].v_videoPath);
      });
      return true;
    } catch (e) {
      print(e);
    }

    return false;
  }
 

  bool deleteFolder(String path) {
    try {
      Directory(path).deleteSync(recursive: true);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  bool renameFolder(String f_path, String newftitle) {
    try {
      Directory(f_path).renameSync(
          f_path.substring(0, f_path.lastIndexOf(Platform.pathSeparator) + 1) +
              newftitle);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  bool deleteFile(String path) {
    try {

      if (File(path).existsSync()) {
          File(path).deleteSync(recursive: false);
      
   
      //print(thumbailpath);
      String thumbailpath =get_thumbail_path(path);
      if (File(thumbailpath).existsSync()) {
        File(thumbailpath).deleteSync(recursive: false);
      }

      return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

String? rename_thumbaile(String? path,String newtitle)
{
  if(path==null){
    return null;
  }
          String oldpath =get_thumbail_path(path);

          if (File(oldpath).existsSync()) {
             var lastSeparator = newtitle.lastIndexOf('.');
             var newPath = newtitle.substring(0, lastSeparator);
             String new_thumbail_path="/storage/emulated/0/neo_player/" + newPath + ".jpg";
             File(oldpath).renameSync(new_thumbail_path);
             return new_thumbail_path;

          }
    return oldpath;

}




  bool renamefile(String f_path, String newftitle) {
    try {

      if (File(f_path).existsSync()) {
          File(f_path).renameSync(
              f_path.substring(0, f_path.lastIndexOf(Platform.pathSeparator) + 1) +
                  newftitle);
          rename_thumbaile(f_path,newftitle);
           return true;
        }

      return false;
       

    } catch (e) {
      print(e);
      return false;
    }
  }

  // Future<String> gethumbail(String path) async {
  //   final db = await playerDatabase.instance;
  //   String thumbailpath = path.substring(0, path.lastIndexOf(".")) + ".jpg";
  //   if (await File(thumbailpath).exists()) {
  //     return thumbailpath;
  //   } else {
  //     final VideoPlayerController controller = VideoPlayerController.file(File(path));
  //     await controller.initialize();
  //     final int duration = controller.value.duration.inMilliseconds;
  //     final int position = duration ~/ 2;
  //     final VideoFrame frame = await controller.getVideoFrame(
  //       VideoFrameFormat.jpeg,
  //       position: Duration(milliseconds: position),
  //     );
  //     final Uint8List imageBytes = frame.image.planes[0].bytes;
  //     final File imageFile = File(thumbailpath);
  //     await imageFile.writeAsBytes(imageBytes);
  //     await controller.dispose();
  //     db.create_thumbaile(Thumbail_path(v_thumbnailPath: thumbailpath, v_videoPath: path));
  //     return thumbailpath;
  //   }
  // }

// getfromdatabase(String path)async{
//   final db = await playerDatabase.instance;
//   String val;
//   var res=db.thumbail_path(path).then((value) => {val= value.v_thumbnailPath});
//  //print(res);
//   return res;
// }

//   gethumbail(path) {

//     getfromdatabase(path);
//     // if (File(thumbpath).existsSync()) {
//     //   return null;
//     // } else {
//     //   return "assets/images/placeholder.jpg";
//     // }
//     return null;

//   }

}
