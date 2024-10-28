import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseHelper {
  static const _databaseName = 'project.db';
  static const _databaseVersion = 1;

  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async =>
      _database ??= await _initializeDatabase();

  _initializeDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = p.join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  delDatabase() async {
    var databasesPath = await getDatabasesPath();
    var path = p.join(databasesPath, _databaseName);

    await deleteDatabase(path);
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE days (
        id      INTEGER PRIMARY KEY AUTOINCREMENT,
        name    TEXT NOT NULL,
        weekday TEXT NOT NULL UNIQUE
      );
    ''');

    await db.execute('''
      CREATE TABLE meals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        day_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        image TEXT,
        FOREIGN KEY (day_id) REFERENCES days(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE ingredients (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        calories INTEGER NOT NULL,
        proteins REAL NOT NULL,
        fats REAL NOT NULL,
        carbohydrates REAL NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE dishes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        meal_id INTEGER NOT NULL,
        name TEXT NOT NULL,
        image TEXT,
        FOREIGN KEY (meal_id) REFERENCES meals(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE dish_ingredients (
        dish_id INTEGER,
        ingredient_id INTEGER,
        weight INTEGER NOT NULL,
        PRIMARY KEY (dish_id, ingredient_id),
        FOREIGN KEY (dish_id) REFERENCES dishes(id) ON DELETE CASCADE,
        FOREIGN KEY (ingredient_id) REFERENCES ingredients(id) ON DELETE CASCADE
      );
    ''');
  }
}
