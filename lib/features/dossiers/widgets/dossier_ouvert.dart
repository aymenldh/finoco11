import 'package:finoco/core/models/client.dart';
import 'package:finoco/features/clients/widgets/client_totale_widget.dart';
import 'package:finoco/features/dossiers/bloc/dossier_bloc.dart';
import 'package:finoco/features/dossiers/bloc/dossier_event.dart';
import 'package:finoco/features/dossiers/bloc/dossier_state.dart';
import 'package:finoco/features/dossiers/dossier_details_page.dart';
import 'package:finoco/features/dossiers/widgets/dossier_widget.dart';
import 'package:finoco/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DossierOuvert extends StatelessWidget {
  final Client? client;
  const DossierOuvert({Key? key, this.client}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<DossierBloc>().add(LoadDossiers(true, client!.id!));
    return BlocBuilder<DossierBloc, DossierState>(builder: (context, state) {
      if (state is DossiersLoaded) {
        return Stack(
          children: [
            RefreshIndicator(
              onRefresh: () {
                context.read<DossierBloc>().add(LoadDossiers(true, client!.id!));
                return Future.delayed(const Duration(milliseconds: 100));
              },
              child: ListView(
                padding: EdgeInsets.zero,
                children: state.dossiers
                    .map(
                      (dossier) => InkWell(
                        onTap: () => clientNavigatorKey.currentState!.push(
                          MaterialPageRoute(
                            builder: (context) => DossierDetails(
                              dossier: dossier,
                            ),
                          ),
                        ),
                        child: DossierWidget(
                          dossier: dossier,
                          client: client,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            Positioned(
              bottom: 0,
              child: ClientTotaleWidget(
                idClient: client!.id!,
              ),
            ),
          ],
        );
      } else {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
    });
  }
}
