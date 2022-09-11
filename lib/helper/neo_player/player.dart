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
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    // await db.execute('''CREATE TABLE $folder_databasename( 
    //   ${folder_database.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    //   ${folder_database.folder_name} TEXT NOT NULL,
    //   ${folder_database.folder_path} TEXT NOT NULL,
    //   ${folder_database.folder_size} TEXT NOT NULL,
    //   ${folder_database.folder_date} TEXT NOT NULL,
    //   )
    // ''');

    // await db.execute('''CREATE TABLE $Video_databasename( 
    //   ${video_database.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    //   ${video_database.Video_name} TEXT NOT NULL,
    //   ${video_database.Video_path} TEXT NOT NULL,
    //   ${video_database.Video_size} TEXT NOT NULL,
    //   ${video_database.Video_date} TEXT NOT NULL,
    //   ${video_database.Video_duration} TEXT NOT NULL,
    //   ${video_database.Video_watched} TEXT NOT NULL,
    //   ${video_database.Video_type} INTEGER NOT NULL,
    //   ${video_database.Video_folder_id} INTEGER NOT NULL,
    //   ${video_database.Video_playlist_id} INTEGER NOT NULL,
    //   ${video_database.Video_thumbnail_path} TEXT NOT NULL,
    //   ${video_database.Video_open} BOOLEAN NOT NULL,
    //   ${video_database.Video_favourite} BOOLEAN NOT NULL,
    //   ${video_database.Video_lastmodified} TEXT NOT NULL,
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

  // create_thumbaile(  Thumbail_path  thumbai) async {
  //   final db = await instance.database;
  //   final res = await db.insert(video_thumbailedatabase, thumbai.toJson());
    
  //   // return Thumbail_path.copy();
  //   //return false;
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