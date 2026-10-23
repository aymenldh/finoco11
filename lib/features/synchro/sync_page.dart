import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/core/shared/widgets/button_raised.dart';
import 'package:finoco/core/shared/widgets/scaffold_header.dart';
import 'package:finoco/features/accueil/stats/stats_bloc.dart';
import 'package:finoco/features/accueil/stats/stats_event.dart';
import 'package:finoco/features/clients/bloc/client_bloc.dart';
import 'package:finoco/features/clients/bloc/client_event.dart';
import 'package:finoco/features/synchro/bloc/sync_bloc.dart';
import 'package:finoco/features/synchro/bloc/sync_event.dart';
import 'package:finoco/features/synchro/bloc/sync_state.dart';
import 'package:finoco/features/synchro/stats_diff.dart';
import 'package:finoco/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class SynchroScreen extends StatefulWidget {
  const SynchroScreen({Key? key}) : super(key: key);

  @override
  State<SynchroScreen> createState() => _SynchroScreenState();
}

class _SynchroScreenState extends State<SynchroScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  DateTime preBackpress = DateTime.now().add(const Duration(seconds: -10));

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: synchroNavigatorKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
            builder: (context) => ScaffoldHeader(
                  screen: 2,
                  showBackButton: false,
                  title: 'Synchronisation',

                  child: DifferenceStats(),

                  // Padding(
                  //   padding: const EdgeInsets.all(25.0),
                  //   child: ButtonRaised(
                  //     onPressed: () {
                  //       showDialog(
                  //         context: context,
                  //         builder: (context) {
                  //           final devisesTEC = TextEditingController();
                  //           return AlertDialog(
                  //             shape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(15)),
                  //             scrollable: true,
                  //             content: Container(
                  //               height: 230,
                  //               child: Column(
                  //                 children: [
                  //                   const Text(
                  //                     'Ajouter devise',
                  //                     style:
                  //                         AppThemes.sectionTitleTextStyle,
                  //                   ),
                  //                   const SizedBox(
                  //                     height: 50,
                  //                   ),
                  //                   CustomTextField(
                  //                     controller: devisesTEC,
                  //                   ),
                  //                   const SizedBox(
                  //                     height: 35,
                  //                   ),
                  //                   Row(
                  //                     children: [
                  //                       ButtonRaised(
                  //                         title: 'Annuler',
                  //                         onPressed: () =>
                  //                             Navigator.pop(context),
                  //                       ),
                  //                       const SizedBox(
                  //                         width: 20,
                  //                       ),
                  //                       ButtonRaised(
                  //                         title: 'Enregistrer',
                  //                         onPressed: () {
                  //                           setState(() {});
                  //                           clientNavigatorKey.currentState
                  //                               .pop();
                  //                         },
                  //                       ),
                  //                     ],
                  //                   )
                  //                 ],
                  //               ),
                  //             ),
                  //           );
                  //         },
                  //       );
                  //     },
                  //     title: 'Ajoutez devise',
                  //   ),
                  // ),
                )));
  }
}
