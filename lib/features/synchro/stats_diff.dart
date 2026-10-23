import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/core/models/tables_stats.dart';
import 'package:finoco/core/shared/widgets/button_raised.dart';
import 'package:finoco/features/accueil/stats/stats_bloc.dart';
import 'package:finoco/features/accueil/stats/stats_event.dart';
import 'package:finoco/features/clients/bloc/client_bloc.dart';
import 'package:finoco/features/clients/bloc/client_event.dart';
import 'package:finoco/features/synchro/bloc/sync_bloc.dart';
import 'package:finoco/features/synchro/bloc/sync_event.dart';
import 'package:finoco/features/synchro/bloc/sync_state.dart';
import 'package:finoco/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sqflite/sqflite.dart';

class DifferenceStats extends StatefulWidget {
  DifferenceStats({Key key}) : super(key: key);

  @override
  State<DifferenceStats> createState() => _DifferenceStatsState();
}

class _DifferenceStatsState extends State<DifferenceStats> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<SyncBloc, SyncState>(
      listener: (context, state) {
        if (state is SyncSuccess) {
          clientNavigatorKey.currentContext
              .read<ClientBloc>()
              .add(LoadClients(''));
          accueilNavigatorKey.currentContext.read<StatsBloc>().add(LoadStats());
        }
      },
      child: BlocBuilder<SyncBloc, SyncState>(
        builder: (context, state) {
          if (state is SyncInProgress) {
            return const Center(child: const CircularProgressIndicator());
          } else if (state is SyncFailure) {
            return const Center(child: Text('Error'));
          } else if (state is SyncSuccess) {
            return buildComparisonTable(state.localStats, state.remoteStats);
          } else {
            return const Center(child: const Text('No data available.'));
          }
        },
      ),
    );
  }

  // final List<String> tableNames = [
  //   'Client',
  //   'Dossier',
  //   'Iteration',
  // ];

  // Future<Map<String, Map<String, int>>> getDifferences() async {
  //   final remoteFile = await downloadDatabaseFile();
  //   final remoteDb = await openRemoteDatabase(remoteFile);

  //   try {
  //     return await compareDatabases(remoteDb, tableNames);
  //   } finally {
  //     await closeDatabases(remoteDb);
  //   }
  // }

  // Future<File> downloadDatabaseFile() async {
  //   final ref =
  //       FirebaseStorage.instance.ref().child('databases/local_database.db');
  //   final tempDir = await getTemporaryDirectory();
  //   final localFile = File('${tempDir.path}/downloaded_database.sql');

  //   await ref.writeToFile(localFile);
  //   return localFile;
  // }

  // Future<Database> openRemoteDatabase(File remoteDbFile) async {
  //   try {
  //     final db = await openDatabase(remoteDbFile.path);
  //     print('Remote database opened successfully.');
  //     return db;
  //   } catch (e) {
  //     print('Error opening remote database: $e');
  //     throw Exception('Failed to open remote database.');
  //   }
  // }

  // Future<Map<String, Map<String, int>>> compareDatabases(
  //     Database remoteDb, List<String> tableNames) async {
  //   final localCounts =
  //       await DatabaseHelper.instance.getLocalRowCounts(tableNames);
  //   final remoteCounts = await getRemoteRowCounts(remoteDb, tableNames);

  //   Map<String, Map<String, int>> differences = {};
  //   for (String tableName in tableNames) {
  //     differences[tableName] = {
  //       'local': localCounts[tableName] ?? 0,
  //       'remote': remoteCounts[tableName] ?? 0,
  //     };
  //   }
  //   return differences;
  // }

  // Future<int> countRowsInTable(Database db, String tableName) async {
  //   final count = Sqflite.firstIntValue(
  //       await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  //   return count ?? 0;
  // }

  // Future<Map<String, int>> getRemoteRowCounts(
  //     Database remoteDb, List<String> tableNames) async {
  //   Map<String, int> remoteCounts = {};
  //   for (String tableName in tableNames) {
  //     remoteCounts[tableName] = await countRowsInTable(remoteDb, tableName);
  //   }
  //   return remoteCounts;
  // }

  // Future<Map<String, int>> parseSqlFile(
  //     File sqlFile, List<String> tableNames) async {
  //   final fileContent = await sqlFile.readAsString();
  //   Map<String, int> remoteCounts = {};

  //   for (String tableName in tableNames) {
  //     final regex =
  //         RegExp(r'INSERT INTO ' + tableName + r' ', caseSensitive: false);
  //     final matches = regex.allMatches(fileContent).length;
  //     remoteCounts[tableName] = matches;
  //   }

  //   return remoteCounts;
  // }

  Widget buildComparisonTable(TablesStats local, TablesStats remote) {
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      IconButton(
          onPressed: () {
            context.read<SyncBloc>().add(LoadDatabaseStats());
          },
          icon: const Icon(Icons.refresh)),
      Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 15,
                spreadRadius: 0,
                color: const Color(0xffCDCDCD).withOpacity(.4)),
          ],
          color: AppColor.appSecondaryBackground,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Base des données serveur : ',
              style: AppThemes.sectionTitleTextStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (remote.clients < local.clients)
                  const Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                const Expanded(
                  child: Text(
                    'Nombre des clients : ',
                    style: AppThemes.bigTextStyle,
                  ),
                ),
                Text(
                  remote.clients.toString(),
                  style: AppThemes.sectionTitleTextStyle,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (remote.dossiers < local.dossiers)
                  const Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                const Expanded(
                  child: Text(
                    'Nombre des dossiers : ',
                    style: AppThemes.bigTextStyle,
                  ),
                ),
                Text(
                  remote.dossiers.toString(),
                  style: AppThemes.sectionTitleTextStyle,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (remote.services < local.services)
                  const Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                const Expanded(
                  child: Text(
                    'Nombre des services : ',
                    style: AppThemes.bigTextStyle,
                  ),
                ),
                Text(
                  remote.services.toString(),
                  style: AppThemes.sectionTitleTextStyle,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (remote.paiements < local.paiements)
                  const Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                const Expanded(
                  child: Text(
                    'Nombre des paiements : ',
                    style: AppThemes.bigTextStyle,
                  ),
                ),
                Text(
                  remote.paiements.toString(),
                  style: AppThemes.sectionTitleTextStyle,
                ),
              ],
            ),
          ],
        ),
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 15,
                spreadRadius: 0,
                color: const Color(0xffCDCDCD).withOpacity(.4)),
          ],
          color: AppColor.appSecondaryBackground,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ButtonRaised(
              enabled: !(local.clients == 0 &&
                  local.dossiers == 0 &&
                  local.paiements == 0 &&
                  local.services == 0),
              onPressed: () {
                context.read<SyncBloc>().add(UploadToFirebase());
              },
              icon: const Icon(
                Icons.upload_rounded,
                color: Colors.white,
                size: 52,
              ),
            ),
            ButtonRaised(
              onPressed: () {
                context.read<SyncBloc>().add(DownloadFromFirebase());
              },
              icon: const Icon(
                Icons.download_rounded,
                color: Colors.white,
                size: 52,
              ),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 4),
                blurRadius: 15,
                spreadRadius: 0,
                color: const Color(0xffCDCDCD).withOpacity(.4)),
          ],
          color: AppColor.appSecondaryBackground,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Base des données locale : ',
              style: AppThemes.sectionTitleTextStyle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (remote.clients > local.clients)
                  const Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                const Expanded(
                  child: Text(
                    'Nombre des clients : ',
                    style: AppThemes.bigTextStyle,
                  ),
                ),
                Text(
                  local.clients.toString(),
                  style: AppThemes.sectionTitleTextStyle,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (remote.dossiers > local.dossiers)
                  const Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                const Expanded(
                  child: Text(
                    'Nombre des dossiers : ',
                    style: AppThemes.bigTextStyle,
                  ),
                ),
                Text(
                  local.dossiers.toString(),
                  style: AppThemes.sectionTitleTextStyle,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (remote.services > local.services)
                  const Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                const Expanded(
                  child: Text(
                    'Nombre des services : ',
                    style: AppThemes.bigTextStyle,
                  ),
                ),
                Text(
                  local.services.toString(),
                  style: AppThemes.sectionTitleTextStyle,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (remote.paiements > local.paiements)
                  const Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                const Expanded(
                  child: Text(
                    'Nombre des paiements : ',
                    style: AppThemes.bigTextStyle,
                  ),
                ),
                Text(
                  local.paiements.toString(),
                  style: AppThemes.sectionTitleTextStyle,
                ),
              ],
            ),
          ],
        ),
      )
    ]);
  }

  Future<void> closeDatabases(Database remoteDb) async {
    await remoteDb.close();
  }
}
