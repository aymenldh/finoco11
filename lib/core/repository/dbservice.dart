// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseService {
//   static final DatabaseService _instance = DatabaseService._internal();
//   factory DatabaseService() => _instance;

//   DatabaseService._internal();

//   static Database? _database;

//   Future<Database?> get database async {
//     if (_database != null) return _database;
//     _database = await _initDB();
//     return _database;
//   }

//   Future<Database> _initDB() async {
//     String path = join(await getDatabasesPath(), 'finance_manager.db');
//     return await openDatabase(path, version: 1, onCreate: _onCreate);
//   }

//   Future<void> _onCreate(Database db, int version) async {
//     // Create Clients Table
//     await db.execute('''
//       CREATE TABLE clients (
//         id TEXT PRIMARY KEY,
//         name TEXT,
//         phone TEXT,
//         created_at TEXT
//       )
//     ''');

//     // Create Dossiers Table
//     await db.execute('''
//       CREATE TABLE dossiers (
//         id TEXT PRIMARY KEY,
//         id_client TEXT,
//         name TEXT,
//         type_folder TEXT,
//         status_folder TEXT,
//         created_at TEXT,
//         FOREIGN KEY(id_client) REFERENCES clients(id)
//       )
//     ''');

//     // Create Payments Table
//     await db.execute('''
//       CREATE TABLE payments (
//         id TEXT PRIMARY KEY,
//         id_folder_pay TEXT,
//         name TEXT,
//         montant_paiement REAL,
//         description_paiement TEXT,
//         created_at TEXT,
//         is_synced INTEGER DEFAULT 0,
//         FOREIGN KEY(id_folder_pay) REFERENCES dossiers(id)
//       )
//     ''');

//     // Create Services Table
//     await db.execute('''
//       CREATE TABLE services (
//         id TEXT PRIMARY KEY,
//         id_folder_srv TEXT,
//         name TEXT,
//         cout REAL,
//         frais REAL,
//         description_service TEXT,
//         created_at TEXT,
//         is_synced INTEGER DEFAULT 0,
//         FOREIGN KEY(id_folder_srv) REFERENCES dossiers(id)
//       )
//     ''');
//   }

//   // CRUD Operations for Clients
//   Future<void> insertClient(Map<String, dynamic> client) async {
//     final db = await database;
//     await db?.insert('clients', client,
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   Future<List<Map<String, dynamic>>> getClients() async {
//     final db = await database;
//     return await db?.query('clients') ?? [];
//   }

//   Future<void> updateClient(String id, Map<String, dynamic> client) async {
//     final db = await database;
//     await db?.update('clients', client, where: 'id = ?', whereArgs: [id]);
//   }

//   Future<void> deleteClient(String id) async {
//     final db = await database;
//     await db?.delete('clients', where: 'id = ?', whereArgs: [id]);
//   }

//   // CRUD Operations for Dossiers
//   Future<void> insertDossier(Map<String, dynamic> dossier) async {
//     final db = await database;
//     await db?.insert('dossiers', dossier,
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   Future<List<Map<String, dynamic>>> getDossiersByClient(
//       String clientId) async {
//     final db = await database;
//     return await db?.query('dossiers',
//             where: 'id_client = ?', whereArgs: [clientId]) ??
//         [];
//   }

//   Future<List<Map<String, dynamic>>> getDossiers() async {
//     final db = await database;
//     return await db?.query(
//           'dossiers',
//         ) ??
//         [];
//   }

//   Future<void> updateDossier(String id, Map<String, dynamic> dossier) async {
//     final db = await database;
//     await db?.update('dossiers', dossier, where: 'id = ?', whereArgs: [id]);
//   }

//   Future<void> deleteDossier(String id) async {
//     final db = await database;
//     await db?.delete('dossiers', where: 'id = ?', whereArgs: [id]);
//   }

//   // CRUD Operations for Payments
//   Future<void> insertPayment(Map<String, dynamic> payment) async {
//     final db = await database;
//     await db?.insert('payments', payment,
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   Future<List<Map<String, dynamic>>> getPaymentsByDossier(
//       String dossierId) async {
//     final db = await database;
//     return await db?.query('payments',
//             where: 'id_folder_pay = ?', whereArgs: [dossierId]) ??
//         [];
//   }

//   Future<void> updatePayment(String id, Map<String, dynamic> payment) async {
//     final db = await database;
//     await db?.update('payments', payment, where: 'id = ?', whereArgs: [id]);
//   }

//   Future<void> deletePayment(String id) async {
//     final db = await database;
//     await db?.delete('payments', where: 'id = ?', whereArgs: [id]);
//   }

//   // CRUD Operations for Services
//   Future<void> insertService(Map<String, dynamic> service) async {
//     final db = await database;
//     await db?.insert('services', service,
//         conflictAlgorithm: ConflictAlgorithm.replace);
//   }

//   Future<List<Map<String, dynamic>>> getServicesByDossier(
//       String dossierId) async {
//     final db = await database;
//     return await db?.query('services',
//             where: 'id_folder_srv = ?', whereArgs: [dossierId]) ??
//         [];
//   }

//   Future<void> updateService(String id, Map<String, dynamic> service) async {
//     final db = await database;
//     await db?.update('services', service, where: 'id = ?', whereArgs: [id]);
//   }

//   Future<void> deleteService(String id) async {
//     final db = await database;
//     await db?.delete('services', where: 'id = ?', whereArgs: [id]);
//   }

//   // Combine Payments and Services as Transactions
//   Future<List<Map<String, dynamic>>> getTransactions(String dossierId) async {
//     final db = await database;

//     // Query payments for the dossier
//     List<Map<String, dynamic>> payments = await db?.query(
//           'payments',
//           where: 'id_folder_pay = ?',
//           whereArgs: [dossierId],
//         ) ??
//         [];

//     // Query services for the dossier
//     List<Map<String, dynamic>> services = await db?.query(
//           'services',
//           where: 'id_folder_srv = ?',
//           whereArgs: [dossierId],
//         ) ??
//         [];

//     // Combine both results and return as "transactions"
//     List<Map<String, dynamic>> transactions = [...payments, ...services];

//     return transactions;
//   }

//   // Sync status update (for offline-to-online sync)
//   Future<void> updateSyncStatus(String table, String id, int status) async {
//     final db = await database;
//     await db?.update(table, {'is_synced': status},
//         where: 'id = ?', whereArgs: [id]);
//   }

//   // Fetch unsynced payments or services (for synchronization)
//   Future<List<Map<String, dynamic>>> getUnsyncedItems(String table) async {
//     final db = await database;
//     return await db?.query(table, where: 'is_synced = ?', whereArgs: [0]) ?? [];
//   }

//   // Clear all data (for testing purposes or reinitialization)
//   Future<void> clearAllData() async {
//     final db = await database;
//     await db?.delete('clients');
//     await db?.delete('dossiers');
//     await db?.delete('payments');
//     await db?.delete('services');
//   }
// }
