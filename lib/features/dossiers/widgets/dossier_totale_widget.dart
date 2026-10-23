import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/core/models/dossier.dart';
import 'package:finoco/core/models/statistiques.dart';
import 'package:finoco/core/repository/dbhelper.dart';
import 'package:flutter/material.dart';

class DossierTotaleWidget extends StatelessWidget {
  final Dossier dossier;
  final bool isAddIteration;
  const DossierTotaleWidget({
    Key key,
    this.dossier,
    this.isAddIteration = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: FutureBuilder<Statistiques>(
        future: dossier.devise == 'TND'
            ? DatabaseHelper.instance.getTNDStatsByDossier(dossier.id)
            : DatabaseHelper.instance.getDossierStats(dossier.id),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (dossier.devise == 'TND')
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        isAddIteration
                            ? 'Totale dossier courant :'
                            : 'Totale :',
                        style: AppThemes.titleTextStyle),
                    Text(snapshot.data.somme.toStringAsFixed(0) + ' TND',
                        style: snapshot.data.somme.isNegative
                            ? AppThemes.monnaieTextStyle
                                .copyWith(color: Colors.red)
                            : AppThemes.monnaieTextStyle)
                  ],
                ),
              if (dossier.devise != 'TND') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                          isAddIteration
                              ? 'Totale dossier courant devise:'
                              : 'Totale principale :',
                          style: AppThemes.titleTextStyle),
                    ),
                    Text(
                        snapshot.data.sommeDevise.toStringAsFixed(0) +
                            ' ' +
                            dossier.devise,
                        style: snapshot.data.somme.isNegative
                            ? AppThemes.monnaieTextStyle
                                .copyWith(color: Colors.red)
                            : AppThemes.monnaieTextStyle)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        isAddIteration
                            ? 'Totale dossier courant TND:'
                            : 'Totale TND :',
                        style: AppThemes.titleTextStyle),
                    Text(snapshot.data.somme.toStringAsFixed(0) + ' TND',
                        style: snapshot.data.somme.isNegative
                            ? AppThemes.monnaieTextStyle
                                .copyWith(color: Colors.red)
                            : AppThemes.monnaieTextStyle)
                  ],
                ),
              ]
            ],
          );
        },
      ),
    );
  }
}
