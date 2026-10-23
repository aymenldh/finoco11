import 'package:finoco/core/repository/db_stats_helper.dart';
import 'package:finoco/core/repository/dbhelper.dart';
import 'package:finoco/features/accueil/stats/stats_bloc.dart';
import 'package:finoco/features/accueil/stats/stats_event.dart';
import 'package:finoco/features/clients/bloc/client_bloc.dart';
import 'package:finoco/features/clients/bloc/client_event.dart';
import 'package:finoco/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'sync_event.dart';
import 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncState> {
  SyncBloc() : super(SyncInitial());

  @override
  Stream<SyncState> mapEventToState(SyncEvent event) async* {
    if (event is UploadToFirebase) {
      yield* _uploadDatabase();
    } else if (event is DownloadFromFirebase) {
      yield* _downloadDatabase();
    } else if (event is LoadDatabaseStats) {
      yield* _loadDatabaseStats();
    }
  }

  // Upload current database to Firebase Storage
  Stream<SyncState> _uploadDatabase() async* {
    yield SyncInProgress();
    try {
      // -- Backup current distant database --
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp_file');

      await FirebaseStorage.instance
          .ref("databases/local_database.db")
          .writeToFile(tempFile);

      final targetRef = FirebaseStorage.instance
          .ref('backups/${DateTime.now().millisecondsSinceEpoch}.db');
      await targetRef.putFile(tempFile);
      await tempFile.delete();

      // -- Upload database to firebase storage --
      final localDbPath = await DatabaseHelper.instance.getlocalDatabasePath();
      final statsDB = await DownloadedDatabaseHelper.instance.getDatabasePath();
      final localFile = File(localDbPath);
      await localFile.copy(statsDB);
      final uploadTask = FirebaseStorage.instance
          .ref("databases/local_database.db")
          .putFile(localFile);
      await uploadTask;

      final local = await DatabaseHelper.instance.countRowsInTables();
      final remote =
          await DownloadedDatabaseHelper.instance.countRowsInTables();
      yield SyncSuccess(
        localStats: local,
        remoteStats: remote,
      );
    } catch (e) {
      yield SyncFailure("Error uploading database: $e");
    }
  }

  // Download the Firebase database and replace the local database
  Stream<SyncState> _downloadDatabase() async* {
    yield SyncInProgress();
    try {
      final localDbPath = await DatabaseHelper.instance.getlocalDatabasePath();
      final localFile = File(localDbPath);
      final uploadTask = FirebaseStorage.instance
          .ref('backups/${DateTime.now().millisecondsSinceEpoch}.db')
          .putFile(localFile);
      await uploadTask;

      await DatabaseHelper.instance.downloadDatabaseFromFirebase();
      await DownloadedDatabaseHelper.instance.setFileToDatabase(
          File(await DatabaseHelper.instance.getlocalDatabasePath()));
      final local = await DatabaseHelper.instance.countRowsInTables();
      final remote =
          await DownloadedDatabaseHelper.instance.countRowsInTables();
      yield SyncSuccess(
        localStats: local,
        remoteStats: remote,
      );
    } catch (e) {
      yield SyncFailure("Error downloading database: $e");
    }
  }

  Stream<SyncState> _loadDatabaseStats() async* {
    try {
      final local = await DatabaseHelper.instance.countRowsInTables();
      final remote =
          await DownloadedDatabaseHelper.instance.countRowsInTables();
      yield SyncInProgress();
      yield SyncSuccess(
        localStats: local,
        remoteStats: remote,
      );
    } catch (e) {
      yield SyncFailure("Error uploading database: $e");
    }
  }
}
