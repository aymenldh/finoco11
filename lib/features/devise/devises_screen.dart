import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/core/shared/widgets/button_raised.dart';
import 'package:finoco/core/shared/widgets/custom_textfield.dart';
import 'package:finoco/features/devise/addDeviseDialog.dart';
import 'package:finoco/features/devise/bloc/devise_bloc.dart';
import 'package:finoco/features/devise/bloc/devise_event.dart';
import 'package:finoco/features/devise/bloc/devise_state.dart';
import 'package:finoco/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class DeviseScreen extends StatefulWidget {
  const DeviseScreen({Key key}) : super(key: key);

  @override
  State<DeviseScreen> createState() => _DeviseScreenState();
}

class _DeviseScreenState extends State<DeviseScreen> {
  @override
  void initState() {
    context.read<DeviseBloc>().add(LoadDevises());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35, right: 15, left: 15),
      child: Column(
        children: [
          BlocBuilder<DeviseBloc, DeviseState>(builder: (context, snap) {
            if (snap is DevisesLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snap is DevisesLoaded) {
              return Expanded(
                child: Wrap(
                  runSpacing: 20,
                  spacing: 10,
                  children: snap.devises
                      .map(
                        (e) => Container(
                          width: 120,
                          height: 65,
                          padding: const EdgeInsets.symmetric(
                              vertical: 2.5, horizontal: 7),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: AppColor.grey),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  e.nom,
                                  style: AppThemes.sectionTitleTextStyle,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              if (e.nom != 'TND')
                                IconButton(
                                    onPressed: () {
                                      context
                                          .read<DeviseBloc>()
                                          .add(DeleteDevise(e.id));
                                    },
                                    icon: const Icon(
                                        Icons.delete_outline_outlined,
                                        color: Colors.red))
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            } else {
              return const Center(
                child: Text('Erreur devises'),
              );
            }
          }),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: ButtonRaised(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AddDeviseDialog(),
                );
              },
              title: 'Ajoutez devise',
            ),
          ),
        ],
      ),
    );
  }
}
