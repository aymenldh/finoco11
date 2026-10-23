import 'dart:io';

import 'package:finoco/core/models/tables_stats.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DownloadedDatabaseHelper {
  static final DownloadedDatabaseHelper instance = DownloadedDatabaseHelper._();
  static Database _database;
  static const _databaseName = "downloaded_database.db";
  static const _firebaseFilePath = "databases/downloaded_database.db";

  DownloadedDatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  DownloadedDatabaseHelper._privateConstructor();

  Future<Database> _initDatabase() async {
    final path = await getDatabasePath();
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<String> getDatabasePath() async {
    Directory directory;
    if (Platform.isIOS) {
      directory = await getLibraryDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    final path = join(directory.path, 'downloaded_database.db');
    return path;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE Attachements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idIteration INTEGER,
        url TEXT,
        type TEXT,
        distName TEXT,
        name TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE User (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE Client (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        firstName TEXT,
        lastName TEXT,
        address TEXT,
        phone TEXT,
        email TEXT,
        archiver INTEGER,
        createdAt TEXT,
        notes TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Dossier (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idClient INTEGER,
        name TEXT,
        devise TEXT,
        statusFolder INTEGER,
        archiver INTEGER,
        createdAt TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Devise (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nom TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Iteration (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        idFolder INTEGER,
        idClient INTEGER,
        name TEXT,
        amountTND REAL,
        amountDevise REAL,
        taux REAL,
        devise TEXT,
        description TEXT,
        createdAt TEXT,
        type TEXT,
        operation TEXT
      )
    ''');
  }

  Future<TablesStats> countRowsInTables() async {
    final db = await database; // SQLite database instance
    final countDossier = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM Dossier'));
    final countClient =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM Client'));
    final countIterationService = Sqflite.firstIntValue(await db
        .rawQuery("SELECT COUNT(*) FROM Iteration where type='SERVICE'"));
    final countIterationPaiement = Sqflite.firstIntValue(await db
        .rawQuery("SELECT COUNT(*) FROM Iteration where type='PAIEMENT'"));
    return TablesStats(
      dossiers: countDossier,
      clients: countClient,
      services: countIterationService,
      paiements: countIterationPaiement,
    );
  }

  static int NEW_DB_VERSION = 2;

  Future<void> setFileToDatabase(File file) async {
    try {
      NEW_DB_VERSION = await _database.getVersion() + 1;

      if (_database != null && _database.isOpen) {
        await _database.close();
        print('Existing database closed.');
        _database = null;
      }
      final path = await getDatabasePath();
      await deleteDatabase(path);

      await file.copy(path);
      print("Database downloaded from Firebase");
      _database = await openDatabase(path, version: NEW_DB_VERSION);
    } catch (e) {
      print("Error : $e");
    }
  }
}
