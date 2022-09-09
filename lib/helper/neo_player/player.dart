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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);

  }


  Future _createDB(Database db, int version) async {

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


  }

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
  

  




 Future close() async {
    final db = await instance.database;
    db.close();
  }

 


}