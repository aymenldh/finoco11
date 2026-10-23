import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/core/models/client.dart';
import 'package:finoco/core/repository/dbhelper.dart';
import 'package:finoco/core/shared/widgets/button_raised.dart';
import 'package:finoco/features/clients/add_client.dart';
import 'package:finoco/features/clients/bloc/client_bloc.dart';
import 'package:finoco/features/clients/bloc/client_event.dart';
import 'package:finoco/features/clients/widgets/client_details_widget.dart';
import 'package:finoco/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClientWidget extends StatefulWidget {
  final Client client;
  const ClientWidget(
    this.client, {
    Key? key,
  }) : super(key: key);

  @override
  State<ClientWidget> createState() => _ClientWidgetState();
}

class _ClientWidgetState extends State<ClientWidget> {
  // bool isFav = false;
  @override
  Widget build(BuildContext context) {
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
        borderRadius: const BorderRadius.all(Radius.circular(7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.client.fullName,
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
                        clientNavigatorKey.currentState!.push(MaterialPageRoute(
                          builder: (context) =>
                              AddClientScreen(client: widget.client),
                        ));
                      } else if (value == 'Supprimer') {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              title: const Text(
                                'Supprimer client',
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
                                      "Attention ce client sera supprimer ! \n Risque de perte des données. \n Continuez ?",
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
                                      onPressed: () {
                                        context
                                            .read<ClientBloc>()
                                            .add(DeleteClient(widget.client));
                                        Navigator.pop(context);
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
                            return ClientDetailsWidget(client: widget.client);
                          },
                        );
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'Modifier',
                        child: Text('Modifier'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Supprimer',
                        child: Text('Supprimer'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'Details',
                        child: Text('Détails'),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
          FutureBuilder<double>(
            future:
                DatabaseHelper.instance.getTotalTNDByClient(widget.client.id!),
            builder: (context, snap) {
              if (!snap.hasData) return const SizedBox();
              return Text(
                snap.data!.toStringAsFixed(0) + ' TND',
                style: snap.data!.isNegative
                    ? AppThemes.monnaieTextStyle.copyWith(color: Colors.red)
                    : AppThemes.monnaieTextStyle.copyWith(
                        color: Colors.grey[600],
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
