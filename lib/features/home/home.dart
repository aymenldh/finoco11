import 'package:finoco/features/accueil/screens/accueil_page.dart';
import 'package:finoco/features/clients/clients_page.dart';
import 'package:finoco/features/home/bloc/home_bloc.dart';
import 'package:finoco/features/home/widgets/bottom_navigation.dart';
import 'package:finoco/features/more/more_page.dart';
import 'package:finoco/features/synchro/sync_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          body: IndexedStack(
            index: state.selectedIndex,
            children: const [
              AccueilView(),
              ClientsPage(),
              SynchroScreen(),
              More()
            ],
          ),
          bottomNavigationBar: const BottomNavigation(),
        );
      },
    );
  }
}
