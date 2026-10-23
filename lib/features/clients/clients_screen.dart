import 'package:finoco/core/shared/widgets/custom_search_field.dart';
import 'package:finoco/core/shared/widgets/scaffold_header.dart';
import 'package:finoco/features/clients/add_client.dart';
import 'package:finoco/features/clients/bloc/client_bloc.dart';
import 'package:finoco/features/clients/bloc/client_event.dart';
import 'package:finoco/features/clients/bloc/client_state.dart';
import 'package:finoco/features/clients/widgets/client_widget.dart';
import 'package:finoco/features/dossiers/dossiers_screen.dart';
import 'package:finoco/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({Key key}) : super(key: key);

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {
  TextEditingController searchTEC = TextEditingController();
  FocusNode myFocusNode = FocusNode();

  bool _isTextFieldFocused = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    myFocusNode.addListener(() {
      setState(() {
        _isTextFieldFocused = myFocusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldHeader(
      screen: 1,
      title: 'Clients',
      titleLineWidget: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.add_circle,
            ),
            onPressed: () {
              clientNavigatorKey.currentState.push(MaterialPageRoute(
                builder: (context) => const AddClientScreen(),
              ));
            },
          ),
          // IconButton(
          //   icon: const Icon(
          //     Icons.star_border,
          //   ),
          //   onPressed: () {},
          // ),
        ],
      ),
      bottomAppbar: SizedBox(
        height: 57.5,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: CustomSearchField(
            focusNode: myFocusNode,
            controller: searchTEC,
            borderColor: Colors.grey,
            onChanged: (v) {
              context.read<ClientBloc>().add(LoadClients(v));
            },
            suffix: _isTextFieldFocused || searchTEC.text.isNotEmpty
                ? Icons.close
                : null,
            onPressed: () {
              setState(() {
                searchTEC.clear();
              });
              context.read<ClientBloc>().add(LoadClients(''));
              FocusScope.of(context).requestFocus(FocusNode());
            },
            icon: const Icon(
              Icons.search,
            ),
            hintText: 'Rechercher client',
          ),
        ),
      ),
      showBackButton: false,
      child: BlocBuilder<ClientBloc, ClientState>(
        builder: (context, state) {
          if (state is ClientsLoaded) {
            if (state.client.isEmpty) {
              return const Center(
                child: Text('Pas des clients trouvées'),
              );
            }
            return RefreshIndicator(
              onRefresh: () {
                context.read<ClientBloc>().add(LoadClients(''));
                return Future.delayed(Duration(milliseconds: 100));
              },
              child: ListView(
                padding: EdgeInsets.zero,
                children: state.client
                    .map((client) => InkWell(
                        onTap: () => clientNavigatorKey.currentState
                                .push(MaterialPageRoute(
                              builder: (context) => DossiersScreen(client),
                            )),
                        child: ClientWidget(client)))
                    .toList(),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
