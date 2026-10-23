import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/core/models/type_transaction.dart';
import 'package:finoco/core/repository/dbhelper.dart';
import 'package:finoco/core/shared/widgets/scaffold_header.dart';
import 'package:finoco/features/accueil/screens/accueil_screen.dart';
import 'package:finoco/features/accueil/stats/stats_bloc.dart';
import 'package:finoco/features/accueil/stats/stats_event.dart';
import 'package:finoco/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccueilView extends StatefulWidget {
  const AccueilView({Key key}) : super(key: key);

  @override
  State<AccueilView> createState() => _AccueilViewState();
}

class _AccueilViewState extends State<AccueilView>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: accueilNavigatorKey,
      onGenerateRoute: (settings) => MaterialPageRoute(
        builder: (context) => ScaffoldHeader(
          screen: 0,
          showBackButton: false,
          title: 'Accueil',
          key: scaffoldKey,
          child: const AccueilScreen(),
          titleLineWidget: IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              context.read<StatsBloc>().add(LoadStats());
            },
          ),
        ),
      ),
    );
  }
}
