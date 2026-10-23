import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/core/models/dossier.dart';
import 'package:finoco/core/models/type_transaction.dart';
import 'package:finoco/features/iteration/bloc/iteration_bloc.dart';
import 'package:finoco/features/iteration/bloc/iteration_event.dart';
import 'package:finoco/features/iteration/bloc/iteration_state.dart';
import 'package:finoco/features/iteration/iteration_details.dart';
import 'package:finoco/features/iteration/widgets/iteration_widget.dart';
import 'package:finoco/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../dossiers/widgets/dossier_totale_widget.dart';

class ServicesScreen extends StatefulWidget {
  final Dossier? dossier;
  const ServicesScreen({Key? key, this.dossier}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    context
        .read<IterationBloc>()
        .add(LoadIterations(TypeTransaction.SERVICE.name, widget.dossier!.id!));

    return Stack(
      children: [
        BlocBuilder<IterationBloc, IterationState>(builder: (context, state) {
          if (state is IterationsLoaded) {
            if (state.iterations.isEmpty) {
              return const Center(
                child: Text(
                  'Aucune données trouvées',
                  style: AppThemes.regularTextStyle,
                ),
              );
            }
            return ListView(
              padding: const EdgeInsets.only(top: 10, bottom: 150),
              children: state.iterations
                  .map(
                    (item) => InkWell(
                      onTap: () => clientNavigatorKey.currentState!
                          .push(MaterialPageRoute(
                        builder: (context) => IterationDetails(
                          iteration: item,
                        ),
                      )),
                      child: IterationWidget(
                        iteration: item,
                        dossier: widget.dossier,
                      ),
                    ),
                  )
                  .toList(),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
        Positioned(
          bottom: 0,
          child: DossierTotaleWidget(
            dossier: widget.dossier,
          ),
        ),
      ],
    );
  }
}
