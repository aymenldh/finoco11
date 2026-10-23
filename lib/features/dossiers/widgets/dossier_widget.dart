import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/core/models/client.dart';
import 'package:finoco/core/models/dossier.dart';
import 'package:finoco/core/repository/dbhelper.dart';
import 'package:finoco/core/shared/widgets/button_raised.dart';
import 'package:finoco/features/dossiers/add_dossier/add_dossier_screen.dart';
import 'package:finoco/features/dossiers/bloc/dossier_bloc.dart';
import 'package:finoco/features/dossiers/bloc/dossier_event.dart';
import 'package:finoco/features/dossiers/widgets/dossier_details_widget.dart';
import 'package:finoco/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DossierWidget extends StatefulWidget {
  final Dossier dossier;
  final Client client;
  const DossierWidget({
    Key key,
    this.dossier,
    this.client,
  }) : super(key: key);

  @override
  State<DossierWidget> createState() => _DossierWidgetState();
}

class _DossierWidgetState extends State<DossierWidget> {
  double totale = 1;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
        future: DatabaseHelper.instance
            .getTotaleDevisePrincipaleByDossier(widget.dossier.id),
        builder: (context, snapshot) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
            padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, 4),
                    blurRadius: 15,
                    spreadRadius: 0,
                    color: const Color(0xffCDCDCD).withOpacity(.4)),
              ],
              color: AppColor.appSecondaryBackground,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.dossier.name,
                        style: AppThemes.bigTextStyle
                            .copyWith(color: AppColor.sectionTitleColor),
                      ),
                    ),
                    Row(
                      children: [
                        PopupMenuButton<String>(
                          offset: const Offset(-25, 30),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onSelected: (String value) {
                            // Handle menu item selection
                            if (value == 'Modifier') {
                              clientNavigatorKey.currentState
                                  .push(MaterialPageRoute(
                                builder: (context) =>
                                    AddDossierScreen(dossier: widget.dossier),
                              ));
                            } else if (value == 'Supprimer') {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    title: const Text(
                                      'Supprimer',
                                      style: AppThemes.sectionTitleTextStyle,
                                    ),
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.warning_rounded,
                                          color: Colors.orange,
                                          size: 40,
                                        ),
                                        Expanded(
                                          child: Text(
                                            "Attention ça sera supprimer ! \n Risque de perte des données. \n Continuez ?",
                                            style: AppThemes.kbirShwyTextStyle,
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      ButtonBar(
                                        alignment: MainAxisAlignment.end,
                                        children: [
                                          ButtonRaised(
                                            title: 'Annuler',
                                            onPressed: () =>
                                                Navigator.pop(context),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          ButtonRaised(
                                            title: 'Supprimer',
                                            onPressed: () {
                                              context.read<DossierBloc>().add(
                                                  DeleteDossier(
                                                      widget.dossier));
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else if (value == 'Details') {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return DossierDetailsWidget(
                                      dossier: widget.dossier);
                                },
                              );
                            } else if (value == 'Cloturer') {
                              widget.dossier.statusFolder = false;
                              context
                                  .read<DossierBloc>()
                                  .add(UpdateDossier(widget.dossier));
                            } else if (value == 'ouvrir') {
                              widget.dossier.statusFolder = true;
                              context
                                  .read<DossierBloc>()
                                  .add(OuvrirDossier(widget.dossier));
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'Modifier',
                              child: Text('Modifier'),
                            ),
                            if (widget.dossier.statusFolder &&
                                snapshot.hasData &&
                                snapshot.data == 0)
                              const PopupMenuItem<String>(
                                value: 'Cloturer',
                                child: Text('Clôturer'),
                              ),
                            if (!widget.dossier.statusFolder)
                              const PopupMenuItem<String>(
                                value: 'ouvrir',
                                child: Text('Ouvrir'),
                              ),
                            const PopupMenuItem<String>(
                              value: 'Details',
                              child: Text('Détails'),
                            ),
                            const PopupMenuItem<String>(
                              value: 'Supprimer',
                              child: Text('Supprimer'),
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                if (!snapshot.hasData) const SizedBox(),
                if (snapshot.hasData)
                  Text(
                      snapshot.data.toStringAsFixed(0) +
                          ' ' +
                          widget.dossier.devise,
                      style: snapshot.data.isNegative
                          ? AppThemes.monnaieTextStyle
                              .copyWith(color: Colors.red)
                          : AppThemes.monnaieTextStyle
                              .copyWith(color: Colors.grey[600]))
              ],
            ),
          );
        });
  }
}
