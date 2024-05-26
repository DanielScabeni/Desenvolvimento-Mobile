import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static const _dbName = 'ponto_app.db';
  static const _dbVersion = 1;

  DatabaseProvider._init();
  static final DatabaseProvider instance = DatabaseProvider._init();

  Database? _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initDatabase();
    }
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databasePath = await getDatabasesPath();
    String dbPath = join(databasePath, _dbName);
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        '''
      CREATE TABLE pontos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dia_de_trabalho TEXT NOT NULL,
        data TEXT NOT NULL,
        hora TEXT NOT NULL
      );
      '''
    );

    await db.execute(
        '''
      CREATE TABLE configuracoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hora_inicio1 TEXT NOT NULL,
        hora_fim1 TEXT NOT NULL,
        hora_inicio2 TEXT NOT NULL,
        hora_fim2 TEXT NOT NULL
      );
      '''
    );
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
    }
  }

  Future<void> deleteDatabase() async {
    String databasePath = await getDatabasesPath();
    String dbPath = join(databasePath, _dbName);
    await databaseFactory.deleteDatabase(dbPath);
  }
}
