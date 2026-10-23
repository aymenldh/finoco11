import 'package:finoco/core/shared/widgets/custom_search_field.dart';
import 'package:finoco/core/shared/widgets/scaffold_header.dart';
import 'package:finoco/features/clients/add_client.dart';
import 'package:finoco/features/clients/bloc/client_bloc.dart';
import 'package:finoco/features/clients/bloc/client_event.dart';
import 'package:finoco/features/clients/bloc/client_state.dart';
import 'package:finoco/features/clients/clients_screen.dart';
import 'package:finoco/features/dossiers/dossiers_screen.dart';
import 'package:finoco/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientsPage extends StatefulWidget {
  const ClientsPage({Key? key}) : super(key: key);

  @override
  State<ClientsPage> createState() => _ClientsPageState();
}

class _ClientsPageState extends State<ClientsPage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    context.read<ClientBloc>().add(LoadClients(''));
  }

  @override
  Widget build(BuildContext ctx) {
    return Navigator(
        key: clientNavigatorKey,
        onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: const ClientsScreen()),
            ));
  }
}
