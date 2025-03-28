import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:camscanner/models/file_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  DatabaseService._internal();
  factory DatabaseService() => _instance;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'camscanner.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE files(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        photos TEXT
      )
    ''');
  }

  Future<void> insertFile(FileModel file) async {
    final db = await database;
    await db.insert('files', file.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<FileModel>> getFiles() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('files');
    return List.generate(maps.length, (i) {
      return FileModel.fromMap(maps[i]);
    });
  }
}