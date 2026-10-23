import 'dart:io';

import 'package:finoco/core/models/attachements.dart';
import 'package:finoco/core/models/client.dart';
import 'package:finoco/core/models/dossier.dart';
import 'package:finoco/core/models/iteration.dart';
import 'package:finoco/core/models/montant_devise.dart';
import 'package:finoco/core/models/statistiques.dart';
import 'package:finoco/core/models/tables_stats.dart';
import 'package:finoco/core/models/type_transaction.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._();
  static int NEW_DB_VERSION = 2;

  static Database _database;
  static const _databaseName = "local_database.db";
  static const _firebaseFilePath = "databases/local_database.db";

  DatabaseHelper._();

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  DatabaseHelper._privateConstructor();

  Future<Database> _initDatabase() async {
    final path = await getlocalDatabasePath();
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<String> getlocalDatabasePath() async {
    Directory directory;
    if (Platform.isIOS) {
      directory = await getLibraryDirectory();
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    final path = join(directory.path, 'local_database.db');
    return path;
  }

  Future<String> getDDatabasePath() async {
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

  // CRUD for Attachements
  Future<int> insertAttachment(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('Attachements', row);
  }

  Future<List<Map<String, dynamic>>> getAllAttachments() async {
    final db = await database;
    return await db.query('Attachements');
  }

  Future<int> updateAttachment(int id, Map<String, dynamic> row) async {
    final db = await database;
    return await db
        .update('Attachements', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAttachment(int id) async {
    final db = await database;
    return await db.delete('Attachements', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD for User
  Future<int> insertUser(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('User', row);
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final db = await database;
    return await db.query('User');
  }

  Future<int> updateUser(int id, Map<String, dynamic> row) async {
    final db = await database;
    return await db.update('User', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteUser(int id) async {
    final db = await database;
    return await db.delete('User', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD for Client
  Future<int> insertClient(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('Client', row);
  }

  Future<List<Map<String, dynamic>>> getAllClients() async {
    final db = await database;
    return await db.query('Client');
  }

  Future<int> updateClient(int id, Map<String, dynamic> row) async {
    final db = await database;
    return await db.update('Client', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteClient(int id) async {
    final db = await database;
    return await db.delete('Client', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD for Dossier
  Future<int> insertDossier(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('Dossier', row);
  }

  Future<List<Map<String, dynamic>>> getAllDossiers() async {
    final db = await database;
    return await db.query('Dossier');
  }

  Future<int> updateDossier(int id, Map<String, dynamic> row) async {
    final db = await database;
    return await db.update('Dossier', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteDossier(int id) async {
    final db = await database;
    return await db.delete('Dossier', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD for Devise
  Future<int> insertDevise(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('Devise', row);
  }

  Future<List<Map<String, dynamic>>> getAllDevises() async {
    final db = await database;
    return await db.query('Devise');
  }

  Future<int> updateDevise(int id, Map<String, dynamic> row) async {
    final db = await database;
    return await db.update('Devise', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteDevise(int id) async {
    final db = await database;
    return await db.delete('Devise', where: 'id = ?', whereArgs: [id]);
  }

  // CRUD for Iteration
  Future<int> insertIteration(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert('Iteration', row);
  }

  Future<List<Map<String, dynamic>>> getAllIterations() async {
    final db = await database;
    return await db.query('Iteration');
  }

  Future<int> updateIteration(int id, Map<String, dynamic> row) async {
    final db = await database;
    return await db.update('Iteration', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteIteration(int id) async {
    final db = await database;
    return await db.delete('Iteration', where: 'id = ?', whereArgs: [id]);
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

  // Firebase Sync Methods
  Future<void> saveDatabaseToFirebase() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, _databaseName);
      File dbFile = File(path);

      if (await dbFile.exists()) {
        await FirebaseStorage.instance
            .ref()
            .child(_firebaseFilePath)
            .putFile(dbFile);
        print("Database uploaded to Firebase");
      } else {
        print("Database file does not exist for upload");
      }
    } catch (e) {
      print("Error uploading database to Firebase: $e");
    }
  }

  Future<void> downloadDatabaseFromFirebase() async {
    try {
      NEW_DB_VERSION = await _database.getVersion() + 1;
      if (_database != null && _database.isOpen) {
        await _database.close();
        print('Existing database closed.');
        _database = null;
      }

      final ref = FirebaseStorage.instance.ref().child(_firebaseFilePath);

      final path = await getlocalDatabasePath();

      //delete the old database so you can copy the new one
      await deleteDatabase(path);

      //copy db from assets to database folder
      await ref.writeToFile(File(await getlocalDatabasePath()));

      //open the newly created db
      _database = await openDatabase(path, version: NEW_DB_VERSION);

      print("Database downloaded from Firebase");
    } catch (e) {
      print("Error downloading database from Firebase: $e");
    }
  }

  Future<Statistiques> getDossierStats(int idDossier) async {
    final db = await database;

    List<Map<String, dynamic>> resultService = await db.rawQuery('''
    SELECT 
      d.devise,
      SUM(I.amountDevise) AS totalAmountDevise
    FROM Iteration I
    Join Dossier d on d.id=I.idFolder
    WHERE I.idFolder = ? AND I.devise<>'TND' and I.type= ?
    GROUP BY d.devise
  ''', [idDossier, TypeTransaction.SERVICE.name]);
    List<Map<String, dynamic>> resultPaiement = await db.rawQuery('''
    SELECT 
      d.devise,
      SUM(I.amountDevise) AS totalAmountDevise
    FROM Iteration I
    Join Dossier d on d.id=I.idFolder
    WHERE I.idFolder = ? AND I.devise<>'TND' and I.type= ?
    GROUP BY d.devise
  ''', [idDossier, TypeTransaction.PAIEMENT.name]);

    List<Map<String, dynamic>> resultTotale = await db.rawQuery('''
    SELECT 
      type,
      SUM(amountTND) as amountTND
    FROM Iteration I
    WHERE I.idFolder = ? 
    GROUP BY type
  ''', [idDossier]);

    final stats = Statistiques(
      montantDevises: [],
      somme: 0,
      totalePaiements30: 0,
      totalePaiements: 0,
      totaleServices30: 0,
      totaleServices: 0,
    );
    double amountServ = 0;
    double amountPaie = 0;
    if (resultService.isNotEmpty) {
      amountServ = resultService.first["totalAmountDevise"].toDouble();
    }
    if (resultPaiement.isNotEmpty) {
      amountPaie = resultPaiement.first["totalAmountDevise"].toDouble();
    }
    stats.totaleServices30 = amountServ;
    stats.totalePaiements30 = amountPaie;

    for (var element in resultTotale) {
      if (element['type'] == TypeTransaction.SERVICE.name) {
        stats.totaleServices = element['amountTND'];
      } else {
        stats.totalePaiements = element['amountTND'];
      }
    }
    stats.sommeDevise = stats.totaleServices30 - stats.totalePaiements30;
    stats.somme = stats.totaleServices - stats.totalePaiements;
    return stats;
  }

  Future<Statistiques> getTNDStatsByDossier(int idDossier) async {
    final db = await database;

    List<Map<String, dynamic>> resultTotale = await db.rawQuery('''
    SELECT 
      type,
      SUM(amountTND) as amountTND
    FROM Iteration I
    WHERE I.idFolder = ? 
    GROUP BY type
  ''', [idDossier]);

    final stats = Statistiques(
      montantDevises: [],
      somme: 0,
      totalePaiements30: 0,
      totalePaiements: 0,
      totaleServices30: 0,
      totaleServices: 0,
    );

    for (var element in resultTotale) {
      if (element['type'] == TypeTransaction.SERVICE.name) {
        stats.totaleServices = element['amountTND'];
      } else {
        stats.totalePaiements = element['amountTND'];
      }
    }
    stats.somme = stats.totaleServices - stats.totalePaiements;
    return stats;
  }

  Future<double> getTotaleDevisePrincipaleByDossier(int idDossier) async {
    final db = await database;

    List<Map<String, dynamic>> resultsService = await db.rawQuery('''
    SELECT 
      SUM(I.amountDevise) as amountDevise
    FROM Iteration I
    JOIN Dossier D ON I.idFolder = D.id
    WHERE D.id = ? AND I.type = ? AND I.devise==D.devise
  ''', [idDossier, TypeTransaction.SERVICE.name]);

    List<Map<String, dynamic>> resultsPaiement = await db.rawQuery('''
    SELECT 
      SUM(I.amountDevise) as amountDevise
    FROM Iteration I
    JOIN Dossier D ON I.idFolder = D.id
    WHERE D.id = ? AND I.type = ? AND I.devise==D.devise
  ''', [idDossier, TypeTransaction.PAIEMENT.name]);

    double sumService = resultsService.first['amountDevise'] as double ?? 0.0;
    double sumPayment = resultsPaiement.first['amountDevise'] as double ?? 0.0;

    // Calculate the result
    double result = sumService - sumPayment;
    return result;
  }

  Future<Statistiques> getStatsByClient(int clientId) async {
    final db = await database;
    List<Map<String, dynamic>> resultServ = await db.rawQuery('''
    SELECT 
      I.devise,
      SUM(I.amountDevise) AS totalAmountDevise
    FROM Iteration I
    JOIN Dossier D ON I.idFolder = D.id
    WHERE D.idClient = ?  AND I.devise<>'TND' and I.type= ? 
    GROUP BY I.devise
  ''', [
      clientId,
      TypeTransaction.SERVICE.name,
    ]);
    List<Map<String, dynamic>> resultPaiement = await db.rawQuery('''
    SELECT 
      I.devise,
      SUM(I.amountDevise) AS totalAmountDevise
    FROM Iteration I
    JOIN Dossier D ON I.idFolder = D.id
    WHERE D.idClient = ?  AND I.devise<>'TND' and I.type= ? 
    GROUP BY I.devise
  ''', [
      clientId,
      TypeTransaction.PAIEMENT.name,
    ]);

    List<Map<String, dynamic>> res = await db.rawQuery('''
    SELECT 
      type,
      SUM(I.amountTND) as amountTND
    FROM Iteration I
    JOIN Dossier D ON I.idFolder = D.id
    WHERE d.statusFolder=1 and d.idClient = ? 
    GROUP BY type
  ''', [clientId]);

    final stats = Statistiques(
      montantDevises: [],
      somme: 0,
      totalePaiements30: 0,
      totalePaiements: 0,
      totaleServices30: 0,
      totaleServices: 0,
    );
    stats.montantDevises = calculateTotals(resultServ, resultPaiement)
        .entries
        .map(
          (row) => MontantDevise(row.key, row.value),
        )
        .toList();

    for (var element in res) {
      if (element['type'] == TypeTransaction.SERVICE.name) {
        stats.totaleServices = element['amountTND'];
      } else {
        stats.totalePaiements = element['amountTND'];
      }
    }
    stats.somme = stats.totaleServices - stats.totalePaiements;
    return stats;
  }

  Future<double> getTotalTNDByClient(int clientId) async {
    final db = await database;

    List<Map<String, dynamic>> services = await db.rawQuery('''
      SELECT SUM(I.amountTND) AS totalService
       FROM Iteration I
       JOIN Dossier D ON I.idFolder = D.id
       WHERE D.idClient = ? AND D.statusFolder = 1 AND I.type = ?
  ''', [
      clientId,
      TypeTransaction.SERVICE.name,
    ]);
    List<Map<String, dynamic>> paiements = await db.rawQuery('''
      SELECT SUM(I.amountTND)  AS totalPaiement
       FROM Iteration I
       JOIN Dossier D ON I.idFolder = D.id
       WHERE D.idClient = ? AND D.statusFolder = 1 AND I.type = ? 
  ''', [
      clientId,
      TypeTransaction.PAIEMENT.name,
    ]);

    double sumService = services.first['totalService'] as double ?? 0.0;
    double sumPayment = paiements.first['totalPaiement'] as double ?? 0.0;
    return sumService - sumPayment;
  }

  Future<List<Map<String, dynamic>>> getAmountTNDByType() async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT type,
           SUM(amountTND) AS totalAmountTND
    FROM Iteration
    GROUP BY type
  ''');

    return results;
  }

  // Function to calculate totals by devise (service - paiments)
  Map<String, double> calculateTotals(
      List<Map<String, dynamic>> service, List<Map<String, dynamic>> paiments) {
    Map<String, double> totalByDevise = {};

    // Add service amounts
    for (var entry in service) {
      String devise = entry["devise"];
      double amount = entry["totalAmountDevise"].toDouble();

      totalByDevise[devise] = totalByDevise.containsKey(devise)
          ? totalByDevise[devise] + amount
          : amount;
    }

    // Subtract paiments amounts
    for (var entry in paiments) {
      String devise = entry["devise"];
      double amount = entry["totalAmountDevise"].toDouble();

      totalByDevise[devise] = totalByDevise.containsKey(devise)
          ? totalByDevise[devise] - amount
          : -amount; // If no service, start with negative amount
    }

    return totalByDevise;
  }

  Future<Statistiques> getStats() async {
    final db = await database;

    List<Map<String, dynamic>> resultTotale = await db.rawQuery(
      '''
    SELECT 
      type,
      SUM(amountTND) as amountTND
    FROM Iteration
    GROUP BY type
  ''',
    );
    //   final now = DateTime.now();
    //   final dernier30 = now.add(const Duration(days: -30));

    //   List<Map<String, dynamic>> result30 = await db.rawQuery('''
    //   SELECT
    //     type,
    //     SUM(amountTND) as amountTND
    //   FROM Iteration
    //   where createdAt BETWEEN ? AND ?
    //   GROUP BY type
    // ''', [
    //     "${now.year}-${now.month}-${now.day}",
    //     "${dernier30.year}-${dernier30.month}-${dernier30.day}"
    //   ]);

    // Calculate the result

    List<Map<String, dynamic>> resultServ = await db.rawQuery('''
    SELECT 
      I.devise,
      SUM(I.amountDevise) AS totalAmountDevise
    FROM Iteration I
    JOIN Dossier D ON I.idFolder = D.id
    WHERE I.devise<>'TND' and I.type= ? 
    GROUP BY I.devise
  ''', [
      TypeTransaction.SERVICE.name,
    ]);
    List<Map<String, dynamic>> resultPaiement = await db.rawQuery('''
    SELECT 
      I.devise,
      SUM(I.amountDevise) AS totalAmountDevise
    FROM Iteration I
    JOIN Dossier D ON I.idFolder = D.id
    WHERE I.devise<>'TND' and I.type= ? 
    GROUP BY I.devise
  ''', [
      TypeTransaction.PAIEMENT.name,
    ]);
    final Statistiques statistiques = Statistiques(
      montantDevises: [],
      somme: 0,
      totalePaiements30: 0,
      totalePaiements: 0,
      totaleServices30: 0,
      totaleServices: 0,
    );

    statistiques.montantDevises = calculateTotals(resultServ, resultPaiement)
        .entries
        .map(
          (row) => MontantDevise(row.key, row.value),
        )
        .toList();

    for (var element in resultTotale) {
      if (element['type'] == TypeTransaction.SERVICE.name) {
        statistiques.totaleServices = element['amountTND'];
      } else {
        statistiques.totalePaiements = element['amountTND'];
      }
    }

    // for (var element in result30) {
    //   if (element['type'] == TypeTransaction.SERVICE.name) {
    //     statistiques.totaleServices30 = element['amountTND'];
    //   } else {
    //     statistiques.totalePaiements30 = element['amountTND'];
    //   }
    // }

    // Calculate the result
    return statistiques;
  }

  Future<Statistiques> getStatsByFolder(String type) async {
    final db = await database;

    List<Map<String, dynamic>> resultTotale = await db.rawQuery(
      '''
    SELECT 
      type,
      SUM(amountTND) as amountTND
    FROM Iteration
    GROUP BY type
  ''',
    );
    List<Map<String, dynamic>> resultOuverts = await db.rawQuery(
      '''
    SELECT 
      type,
      SUM(I.amountTND) as amountTND
    FROM Iteration I
    JOIN Dossier D ON I.idFolder = D.id
    GROUP BY type
  ''',
    );
    final Statistiques statistiques = Statistiques(
      somme: 0,
      totalePaiements30: 0,
      totalePaiements: 0,
      totaleServices30: 0,
      totaleServices: 0,
    );

    for (var element in resultTotale) {
      if (element['type'] == TypeTransaction.SERVICE.name) {
        statistiques.totaleServices = element['amountTND'];
      } else {
        statistiques.totalePaiements = element['amountTND'];
      }
    }

    return statistiques;
  }

  Future<double> getAmountTNDBySpecificType(String type) async {
    final db = await database;

    List<Map<String, dynamic>> results = await db.rawQuery('''
    SELECT SUM(amountTND) AS totalAmountTND
    FROM Iteration
    WHERE type = ?
  ''', [type]);

    // Return the total amount or 0.0 if there are no matching records
    return results.isNotEmpty && results[0]["totalAmountTND"] != null
        ? results[0]["totalAmountTND"] as double
        : 0.0;
  }

  Future<List<Client>> getClientsByArchiver(bool archiverStatus) async {
    final db = await database;

    // Convert boolean to integer for SQLite (1 for true, 0 for false)
    int archiverValue = archiverStatus ? 1 : 0;

    // Query the Client table with the specified archiver status
    List<Map<String, dynamic>> results = await db.query(
      'Client',
      where: 'archiver = ?',
      whereArgs: [archiverValue],
    );

    return results.map((e) => Client.fromJson(e)).toList();
  }

  Future<Client> getClientByID(int id) async {
    final db = await database;

    // Query the Client table with the specified archiver status
    List<Map<String, dynamic>> results = await db.query(
      'Client',
      where: 'id = ?',
      whereArgs: [id],
    );

    return results.map((e) => Client.fromJson(e)).toList().first;
  }

  Future<List<Client>> searchClients(String name, {int limit}) async {
    final db = await database;

    // Prepare the query to search by first name, last name, and full name
    List<Map<String, dynamic>> results;

    if (limit != null) {
      results = await db.query(
        'Client',
        distinct: true,
        where:
            " firstName LIKE ? OR lastName LIKE ? OR (firstName || ' ' || lastName) LIKE ?",
        whereArgs: ['%$name%', '%$name%', '%$name%'],
        limit: limit,
      );
    } else {
      results = await db.rawQuery('''
    SELECT DISTINCT * FROM Client
    WHERE firstName LIKE ? OR lastName LIKE ? OR (firstName || ' ' || lastName) LIKE ?
  ''', ['%$name%', '%$name%', '%$name%']);
    }
    return results.map((e) => Client.fromJson(e)).toList();
  }

  Future<List<Iteration>> listIterationsByDossierAndType(
      int idDossier, String type) async {
    final db = await database;

    // Query the Iteration table with the specified idDossier and type
    List<Map<String, dynamic>> results = await db.query(
      'Iteration',
      where: 'idFolder = ? AND type = ?',
      whereArgs: [idDossier, type],
    );

    return results.map((e) => Iteration.fromMap(e)).toList();
  }

  Future<List<Iteration>> listIterationsByDossier(int idDossier) async {
    final db = await database;

    // Query the Iteration table with the specified idDossier and type
    List<Map<String, dynamic>> results = await db.query(
      'Iteration',
      where: 'idFolder = ? ',
      whereArgs: [idDossier],
    );

    return results.map((e) => Iteration.fromMap(e)).toList();
  }

  Future<Iteration> getIterationById(int id) async {
    final db = await database;

    // Query the Iteration table with the specified idDossier and type
    List<Map<String, dynamic>> results = await db.query(
      'Iteration',
      where: 'id = ? ',
      whereArgs: [id],
    );

    return results.map((e) => Iteration.fromMap(e)).toList().first;
  }

  Future<List<Attachements>> getAttachmentsByIdIteration(
      int idIteration) async {
    final db = await database;

    // Query the Attachements table with the specified idIteration
    List<Map<String, dynamic>> results = await db.query(
      'Attachements',
      where: 'idIteration = ?',
      whereArgs: [idIteration],
    );

    // Convert the results to a List of Attachements objects
    List<Attachements> attachmentsList =
        results.map((map) => Attachements.fromJson(map)).toList();

    return attachmentsList;
  }

  Future<List<Dossier>> getDossiersByClientAndStatus(
      int idClient, bool statusFolder) async {
    final db = await database;

    // Convert boolean to integer for SQLite (1 for true, 0 for false)
    int statusValue = statusFolder ? 1 : 0;

    // Query the Dossier table with the specified idClient and statusFolder
    List<Map<String, dynamic>> results = await db.query(
      'Dossier',
      where: 'idClient = ? AND statusFolder = ? AND archiver=0',
      whereArgs: [idClient, statusValue],
    );

    // Convert the results to a List of Dossier objects
    List<Dossier> dossiersList =
        results.map((map) => Dossier.fromJson(map)).toList();

    return dossiersList;
  }

  Future<List<Dossier>> getDossiersByClient(int idClient) async {
    final db = await database;

    // Convert boolean to integer for SQLite (1 for true, 0 for false)

    // Query the Dossier table with the specified idClient and statusFolder
    List<Map<String, dynamic>> results = await db.query(
      'Dossier',
      where: 'idClient = ? AND archiver=0',
      whereArgs: [idClient],
    );

    // Convert the results to a List of Dossier objects
    List<Dossier> dossiersList =
        results.map((map) => Dossier.fromJson(map)).toList();

    return dossiersList;
  }

  Future<Dossier> getDossierByID(int idFolder) async {
    final db = await database;

    // Convert boolean to integer for SQLite (1 for true, 0 for false)

    // Query the Dossier table with the specified idClient and statusFolder
    List<Map<String, dynamic>> results = await db.query(
      'Dossier',
      where: 'id = ? ',
      whereArgs: [idFolder],
    );

    // Convert the results to a List of Dossier objects
    List<Dossier> dossiersList =
        results.map((map) => Dossier.fromJson(map)).toList();

    return dossiersList.first;
  }

  Future<bool> iterationHasAttachments(int idIteration) async {
    final db = await database;

    // Query the Attachements table to check for any records with the specified idIteration
    List<Map<String, dynamic>> results = await db.query(
      'Attachements',
      where: 'idIteration = ?',
      whereArgs: [idIteration],
    );

    // Return true if there are attachments, otherwise false
    return results.isNotEmpty;
  }
}
