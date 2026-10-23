import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/core/models/statistiques.dart';
import 'package:finoco/core/repository/dbhelper.dart';
import 'package:flutter/material.dart';

class ClientTotaleWidget extends StatelessWidget {
  final int idClient;
  const ClientTotaleWidget({
    Key key,
    this.idClient,
  }) : super(key: key);

  // Future<Map<String, double>> calculateTotalAmountTNDForOpenFolders() async {
  //   // Query for open folders
  //   QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //       .collection('dossiers')
  //       .where('status_folder', isEqualTo: true)
  //       .get();

  //   // Get a list of open folder IDs
  //   List<String> openFolderIds =
  //       querySnapshot.docs.map((doc) => doc.id).toList();

  //   // Assuming you have a list of Iteration instances
  //   QuerySnapshot querySnapshotIt = await FirebaseFirestore.instance
  //       .collection('iterations')
  //       .where('id_folder', whereIn: openFolderIds)
  //       .get(); // Your list of iterations
  //   List<Iteration> iterations =
  //       querySnapshotIt.docs.map((e) => Iteration.fromMap(e.data())).toList();
  //   Map<String, double> amountByCurrency = {};
  //   amountByCurrency['TND'] = 0;
  //   // Iterate through each document in the query snapshot

  //   for (var iteration in iterations) {
  //     amountByCurrency['TND'] += iteration.amountTND;
  //     // If this currency already exists in the map, add to its total
  //     if (amountByCurrency.containsKey(iteration.devise)) {
  //       amountByCurrency[iteration.devise] =
  //           amountByCurrency[iteration.devise] + iteration.amountDevise;
  //     } else {
  //       // Otherwise, add this currency to the map
  //       amountByCurrency[iteration.devise] = iteration.amountDevise;
  //     }
  //   }

  //   return amountByCurrency;
  //   // double totalAmountTND = 0.0;

  //   // for (Iteration iteration in iterations) {
  //   //   if (openFolderIds.contains(iteration.idFolder)) {
  //   //     totalAmountTND += iteration.amountTND;
  //   //   }
  //   // }

  //   // return totalAmountTND;
  // }

  // Future<Map<String, double>> calculateAmountDeviseByCurrency() async {
  //   final querySnapshot = await FirebaseFirestore.instance
  //       .collection('iterations')
  //       .where('idClient', isEqualTo: idClient)
  //       .get();

  //   // Initialize a map to store total amount for each currency
  //   Map<String, double> amountByCurrency = {};
  //   amountByCurrency['TND'] = 0;
  //   // Iterate through each document in the query snapshot
  //   for (var doc in querySnapshot.docs) {
  //     Iteration iteration = Iteration.fromMap(doc.data());
  //     amountByCurrency['TND'] += iteration.amountTND;
  //     // If this currency already exists in the map, add to its total
  //     if (amountByCurrency.containsKey(iteration.devise)) {
  //       amountByCurrency[iteration.devise] =
  //           amountByCurrency[iteration.devise] + iteration.amountDevise;
  //     } else {
  //       // Otherwise, add this currency to the map
  //       amountByCurrency[iteration.devise] = iteration.amountDevise;
  //     }
  //   }

  //   return amountByCurrency;
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: FutureBuilder<Statistiques>(
        future: DatabaseHelper.instance.getStatsByClient(idClient),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink();
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SelectableText('Totale client :',
                        style: AppThemes.titleTextStyle),
                    SelectableText(
                      snapshot.data.somme.toStringAsFixed(0) + ' TND',
                      style: snapshot.data.somme.isNegative
                          ? AppThemes.monnaieTextStyle
                              .copyWith(color: Colors.red)
                          : AppThemes.monnaieTextStyle,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Wrap(
                          direction: Axis.horizontal,
                          spacing: 30,
                          children: snapshot.data.montantDevises
                              .map(
                                (e) => SelectableText(
                                    e.montant.toStringAsFixed(0) +
                                        ' ' +
                                        e.devise.toString(),
                                    style: e.montant.isNegative
                                        ? AppThemes.monnaieTextStyle
                                            .copyWith(color: Colors.red)
                                        : AppThemes.monnaieTextStyle),
                              )
                              .toList()),
                    ],
                  ),
                )
              ]);
        },
      ),
    );
  }
}
