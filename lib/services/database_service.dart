import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:camscanner/models/file_model.dart';
import 'package:logger/logger.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  DatabaseService._internal();
  factory DatabaseService() => _instance;

  Database? _database;
  final logger = Logger();

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
    try {
      await db.insert('files', file.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      logger.i("File inserted successfully: ${file.name}");
    } catch (e) {
      logger.e("Error inserting file: $e");
    }
  }

  Future<List<FileModel>> getFiles() async {
    final db = await database;
    try {
      final List<Map<String, dynamic>> maps = await db.query('files');
      logger.i("Files retrieved successfully");
      return List.generate(maps.length, (i) {
        return FileModel.fromMap(maps[i]);
      });
    } catch (e) {
      logger.e("Error retrieving files: $e");
      return [];
    }
  }
}
