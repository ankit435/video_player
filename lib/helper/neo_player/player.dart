import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:file/file.dart';
import 'package:video/helper/file.dart';

class playerDatabase{
 
 static final playerDatabase instance = playerDatabase._init();

static Database? _database;

 playerDatabase._init();

Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('player.db');
    return _database!;
  }

Future<Database> _initDB(String filePath) async {
    const dbPath ="/storage/emulated/0/dataabse/";
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);

  }


  Future _createDB(Database db, int version) async {
    final idTypes = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final idType = 'TEXT PRIMARY KEY ';
    final textType = 'TEXT NOT NULL';
    final textType_without_null = 'TEXT';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';
    final default_value = 'TEXT DEFAULT FALSE';

    
    // await db.execute('''CREATE TABLE $Video_databasename( 
    //   ${video_database.Video_id} $idType,
    //   ${video_database.Video_name} $textType,
    //   ${video_database.Video_path} $textType,
    //   ${video_database.Video_size} $integerType,
    //   ${video_database.Video_date} $textType,
    //   ${video_database.Video_duration} $integerType,
    //   ${video_database.Video_watched} $integerType,
    //   ${video_database.Video_folder_id} $textType,
    //   ${video_database.Video_thumbnail_path} $textType_without_null,
    //   ${video_database.Video_open} $integerType,
    //   ${video_database.Video_favourite} $integerType,
    //   ${video_database.Video_lastmodified} $textType,
    //   ${video_database.Video_playlist_id} $textType,
    //   ${video_database.Video_ListedTime} $textType


    //   )
    // ''');
    await db.execute('''CREATE TABLE $playlist_databasename( 
      ${playlist_database.id} $textType,
      ${playlist_database.playlist_name} $textType, 
      ${playlist_database.p_detail} $textType,
      ${playlist_database.count} $integerType,
      ${playlist_database.p_thumbnailPath} $textType
      )
    ''');
    // await db.execute('''CREATE TABLE $video_thumbailedatabase( 
    //   ${video_thumbnail.v_videoPath} $idType,
    //   ${video_thumbnail.v_thumbnailPath} $textType
    //   )
    // ''');

    await db.execute('''CREATE TABLE $Recent_database( 
      ${Recent_video.R_video_id} $textType,
      ${Recent_video.time_stamp} $integerType,
      ${Recent_video.videos} $textType
      )
    ''');

 

  }







  


//  Future<video> add_video_database(video video) async {
//     final db = await instance.database;
//     final id = await db.insert(Video_databasename, video.toJson());
//      if(id==-1)
//     {
//       throw Exception('Failed to create video');
//     }
//     return   video.copy();
//   }

//   Future<video> update_video_database(video video) async {
//     print(video.v_id);
//     final db = await instance.database;
//     final id = await db.update(Video_databasename, video.toJson(),
//         where: '${video_database.Video_id} = ?', whereArgs: [video.v_id]);
//     if(id==-1)
//     {
//       throw Exception('ID failed not found');
//     }

//     return   video.copy();
//   }

//   Future<video> delete_video_database(video video) async {
//     final db = await instance.database;
//     final id = await db.delete(Video_databasename,
//         where: '${video_database.Video_id} = ?', whereArgs: [video.v_id]);

//     if(id==-1)
//     {
//       throw Exception('Failed to delete not found');
//     }
//       print("rename sucessfully");
//     return video.copy();
//   }

//   Future<List<video>> get_all_video_database() async {
//     final db = await instance.database;
//     final result = await db.query(Video_databasename);
//     return result.map((json) => video.fromJson(json)).toList();
//   }

//   Future<video>getvideo_by_v_id(String v_id) async {
//     final db = await instance.database;
//     final result = await db.query(Video_databasename,where: '${video_database.Video_id} = ?', whereArgs: [v_id]);
    
//     //print(result.length);
//     if(result.isNotEmpty){
//       return result.map((json) => video.fromJson(json)).toList()[0];
//     }
//     else{
//        throw Exception('ID $v_id not found');
//     }

//   }

//   Future<List<video>> get_all_video_database_by_folder_id(String folder_id) async {
//     final db = await instance.database;
//     final result = await db.query(Video_databasename,where: '${video_database.Video_folder_id} = ?', whereArgs: [folder_id]);
//     return result.map((json) => video.fromJson(json)).toList();
//   }


// Future<String> rename_folder_path(String old_path,String new_path) async{
//    final db = await instance.database;
//    final id=await db.rawUpdate("Update $Video_databasename Set ${video_database.Video_folder_id} = '${new_path}' Where ${video_database.Video_folder_id}='${old_path}'");
//    if(id==-1){
//      throw Exception('Failde to update not found');
//    }
//    return new_path;



// }

  

Future<PlayList> create(PlayList playlist) async {
 
    final db = await instance.database;
    final id = await db.insert(playlist_databasename, playlist.toJson());
    return playlist.copy();
  }

Future<PlayList> readPlaylist(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      playlist_databasename,
      columns: playlist_database.values,
      where: '${playlist_database.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return PlayList.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

Future<List<PlayList>> readAllPlaylist() async {
    final db = await instance.database;

    final orderBy = '${playlist_database.playlist_name} ASC';

    final result = await db.query(playlist_databasename, orderBy: orderBy);

    return result.map((json) => PlayList.fromJson(json)).toList();
  }

Future<int> update(PlayList playlist) async {
    final db = await instance.database;

    return db.update(
      playlist_databasename,
      playlist.toJson(),
      where: '${playlist_database.id} = ?',
      whereArgs: [playlist.p_id],
    );
  }

Future<int> delete_playlist(String p_id) async {
    final db = await instance.database;
    return await db.delete(
      playlist_databasename,
      where: '${playlist_database.id} = ?',
      whereArgs: [p_id],
    );
  }


Future<recent_video> insert_recent_video(recent_video recent) async {
 
    final db = await instance.database;
    final id = await db.insert(Recent_database, recent.toJson());
    return recent.copy();
  }

Future<dynamic> readRecent(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      Recent_database,
      columns: Recent_video.values,
      where: '${Recent_video.R_video_id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return recent_video.fromJson(maps.first);
    } else {
      //return null;
    throw Exception('ID $id not found');

    }
    
  }

Future<List<recent_video>> readAllRecent() async {
    final db = await instance.database;

    final orderBy = '${Recent_video.time_stamp} ASC';

    final result = await db.query(Recent_database, orderBy: orderBy);

    return result.map((json) => recent_video.fromJson(json)).toList();
  }

Future<int> update_recent_video(recent_video recent) async {
    final db = await instance.database;
    return db.update(
      Recent_database,
      recent.toJson(),
      where: '${Recent_video.R_video_id} = ?',
      whereArgs: [recent.R_video_id],
    );
  }
Future<int> delete_recent_video(String  R_video_id) async {
    final db = await instance.database;
    return await db.delete(
      Recent_database,
      where: '${Recent_video.R_video_id} = ?',
      whereArgs: [R_video_id],
    );
  

}

Future<int> delete_all_recent_video() async {
    final db = await instance.database;
    return await db.delete(
      Recent_database,
    );
  }


 Future close() async {
    final db = await instance.database;
    db.close();
  }

 


}