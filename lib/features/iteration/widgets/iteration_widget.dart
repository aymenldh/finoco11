import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/core/models/dossier.dart';
import 'package:finoco/core/models/iteration.dart';
import 'package:finoco/core/repository/dbhelper.dart';
import 'package:finoco/core/shared/widgets/button_raised.dart';
import 'package:finoco/features/iteration/add_transaction_screen.dart';
import 'package:finoco/features/iteration/bloc/iteration_bloc.dart';
import 'package:finoco/features/iteration/bloc/iteration_event.dart';
import 'package:finoco/features/iteration/widgets/transfer_bottom_sheet.dart';
import 'package:finoco/features/synchro/bloc/sync_bloc.dart';
import 'package:finoco/features/synchro/bloc/sync_event.dart';
import 'package:finoco/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IterationWidget extends StatelessWidget {
  final Iteration? iteration;
  final Dossier? dossier;
  const IterationWidget({
    Key? key,
    this.iteration,
    this.dossier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (iteration!.description != null &&
                iteration!.description!.isNotEmpty)
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.orange,
              ),
            if (iteration!.description == null || iteration!.description!.isEmpty)
              FutureBuilder<bool>(
                  future: DatabaseHelper.instance
                      .iterationHasAttachments(iteration!.id!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(); // Loading indicator
                    } else if (snapshot.hasError) {
                      return Text("Error: ${snapshot.error}");
                    } else {
                      bool hasAttachments = snapshot.data ?? false;

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (hasAttachments) ...[
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.orange,
                            ),
                          ] else ...[
                            // No icon or message when there are no attachments
                            const SizedBox.shrink(), // Shows nothing
                          ],
                        ],
                      );
                    }
                  }),
            const SizedBox(
              width: 5,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    iteration!.name!,
                    style: AppThemes.tileTitleTextStyle,
                  ),
                  if (iteration!.description != null)
                    Text(
                      iteration!.description!,
                      style: AppThemes.regularTextStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (dossier!.devise == 'TND')
                      Text(iteration!.amountTND!.toStringAsFixed(0) + ' TND',
                          style: AppThemes.monnaieTextStyle),
                    if (dossier!.devise != 'TND') ...[
                      Text(
                          iteration!.amountDevise!.toStringAsFixed(0) +
                              ' ' +
                              iteration!.devise!,
                          style: AppThemes.monnaieTextStyle),
                      Text(iteration!.amountTND!.toStringAsFixed(0) + ' TND',
                          style: AppThemes.monnaieTextStyle),
                    ]
                  ],
                ),
                PopupMenuButton<String>(
                  offset: const Offset(-25, 30),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  onSelected: (String value) {
                    // Handle menu item selection
                    if (value == 'Modifier') {
                      clientNavigatorKey.currentState!.push(
                        MaterialPageRoute(
                          builder: (context) => AddTransactonScreen(
                            iteration: iteration,
                            dossier: dossier,
                            typeTransaction: iteration!.type!,
                          ),
                        ),
                      );
                    } else if (value == 'Transferer') {
                      showBottomSheet(
                          context: context,
                          elevation: 15,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                              bottomLeft: Radius.elliptical(-25, -25),
                              bottomRight: Radius.elliptical(-25, -25),
                            ),
                          ),
                          enableDrag: true,
                          backgroundColor: Colors.white,
                          builder: (context) => TransferButtomSheet(
                                idIteration: iteration!.id!,
                                typeTransaction: iteration!.type!,
                                idClient: dossier!.idClient!,
                                idDossier: iteration!.idFolder!,
                              ));
                    } else if (value == 'Supprimer') {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            title: const Text(
                              'Supprimer iteration',
                              style: AppThemes.sectionTitleTextStyle,
                            ),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  ButtonRaised(
                                    title: 'Supprimer',
                                    onPressed: () async {
                                      await DatabaseHelper.instance
                                          .deleteIteration(
                                        iteration!.id!,
                                      );
                                      context.read<IterationBloc>().add(
                                          LoadIterations(
                                              iteration!.type!.name, dossier!.id!));
                                      synchroNavigatorKey.currentContext!
                                          .read<SyncBloc>()
                                          .add(LoadDatabaseStats());
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'Transferer',
                      child: Text('Transférer'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Modifier',
                      child: Text('Modifier'),
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
        ));
  }
}
