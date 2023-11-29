import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static DatabaseHelper get instance =>
      _databaseHelper ?? DatabaseHelper._instance();
  DatabaseHelper._instance() {
    _databaseHelper = this;
  }

  factory DatabaseHelper() => _databaseHelper ?? DatabaseHelper._instance();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, 'game.db');

    var db = await openDatabase(
      databasePath,
      version: 1,
      onCreate: _onCreate,
    );
    return db;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE HighScoreTetris (
        id INTEGER PRIMARY KEY,
        playerName TEXT,
        score INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE HighScoreSnake (
        id INTEGER PRIMARY KEY,
        playerName TEXT,
        score INTEGER
      )
    ''');
  }

  Future<int> insertHighScoreTetris(String playerName, int newHighScore) async {
    final db = await database;
    return await db!.insert('HighScoreTetris', {
      'playerName': playerName,
      'score': newHighScore,
    });
  }

  Future<int> insertHighScoreSnake(String playerName, int score) async {
    final db = await database;
    return await db!.insert('HighScoreSnake', {
      'playerName': playerName,
      'score': score,
    });
  }

  static const String highScoreTable = 'high_score_table';
  static const String highScoreColumn = 'high_score';

  Future<List<Map<String, dynamic>>> getHighScoresTetris() async {
    final db = await database;
    return await db!.query('HighScoreTetris', orderBy: 'score DESC');
  }

  Future<void> setHighScoreTetris(int score) async {
    final Database db = await instance.database;
    await db.insert(
      highScoreTable,
      {highScoreColumn: score},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getHighScoresSnake() async {
    final db = await database;
    return await db!.query('HighScoreSnake', orderBy: 'score DESC');
  }

  Future<void> resetHighScores() async {
    final db = await database;
    await db!.delete(
        'HighScoreTetris'); // Menghapus semua data dari tabel HighScoreTetris
    await db.delete(
        'HighScoreSnake'); // Menghapus semua data dari tabel HighScoreSnake
  }
}
