// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:file/file.dart';
// import 'package:video/helper/file.dart';

// class playerDatabase{
 
//  static final playerDatabase instance = playerDatabase._init();

//   static Database? _database;

//  playerDatabase._init();

// Future<Database> get database async {
//     if (_database != null) return _database!;

//     _database = await _initDB('player.db');
//     return _database!;
//   }

// Future<Database> _initDB(String filePath) async {
//     final dbPath = await getApplicationDocumentsDirectory();
//     final path = join(dbPath.path, filePath);
//     return await openDatabase(path, version: 1, onCreate: _createDB);

//   }


//   Future _createDB(Database db, int version) async {

//     await db.execute('''CREATE TABLE $folder_databasename( 
//       ${folder_database.id} INTEGER PRIMARY KEY AUTOINCREMENT,
//       ${folder_database.folder_name} TEXT NOT NULL,
//       ${folder_database.folder_path} TEXT NOT NULL,
//       ${folder_database.folder_size} TEXT NOT NULL,
//       ${folder_database.folder_date} TEXT NOT NULL,
//       )
//     ''');

//     await db.execute('''CREATE TABLE $Video_databasename( 
//       ${video_database.id} INTEGER PRIMARY KEY AUTOINCREMENT,
//       ${video_database.Video_name} TEXT NOT NULL,
//       ${video_database.Video_path} TEXT NOT NULL,
//       ${video_database.Video_size} TEXT NOT NULL,
//       ${video_database.Video_date} TEXT NOT NULL,
//       ${video_database.Video_duration} TEXT NOT NULL,
//       ${video_database.Video_watched} TEXT NOT NULL,
//       ${video_database.Video_type} INTEGER NOT NULL,
//       ${video_database.Video_folder_id} INTEGER NOT NULL,
//       ${video_database.Video_playlist_id} INTEGER NOT NULL,
//       ${video_database.Video_thumbnail_path} TEXT NOT NULL,
//       ${video_database.Video_open} BOOLEAN NOT NULL,
//       ${video_database.Video_favourite} BOOLEAN NOT NULL,
//       ${video_database.Video_lastmodified} TEXT NOT NULL,
//       )
//     ''');
//     await db.execute('''CREATE TABLE $playlist_databasename( 
//       ${playlist_database.id} INTEGER PRIMARY KEY AUTOINCREMENT,
//       ${playlist_database.playlist_name} TEXT NOT NULL,
//       ${playlist_database.playlist_thumbnail_path} TEXT NOT NULL,
//       )
//     ''');
//   }





//  Future close() async {
//     final db = await instance.database;

//     db.close();
//   }

// }