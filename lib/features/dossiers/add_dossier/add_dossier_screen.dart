import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/core/models/client.dart';
import 'package:finoco/core/models/dossier.dart';
import 'package:finoco/core/shared/widgets/button_raised.dart';
import 'package:finoco/core/shared/widgets/custom_textfield.dart';
import 'package:finoco/core/shared/widgets/scaffold_header.dart';
import 'package:finoco/features/devise/bloc/devise_bloc.dart';
import 'package:finoco/features/devise/bloc/devise_event.dart';
import 'package:finoco/features/devise/bloc/devise_state.dart';
import 'package:finoco/features/dossiers/bloc/dossier_bloc.dart';
import 'package:finoco/features/dossiers/bloc/dossier_event.dart';
import 'package:finoco/features/dossiers/bloc/dossier_state.dart';
import 'package:finoco/features/synchro/bloc/sync_bloc.dart';
import 'package:finoco/features/synchro/bloc/sync_event.dart';
import 'package:finoco/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddDossierScreen extends StatefulWidget {
  final Dossier? dossier;
  final Client? client;
  const AddDossierScreen({Key? key, this.dossier, this.client})
      : super(key: key);

  @override
  State<AddDossierScreen> createState() => _AddDossierScreenState();
}

class _AddDossierScreenState extends State<AddDossierScreen> {
  final titleController = TextEditingController();

  Dossier? dossier;
  final _formKey = GlobalKey<FormState>();
  String? _selectedDevise;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    context.read<DeviseBloc>().add(LoadDevises());
    if (widget.dossier != null) {
      dossier = widget.dossier!.copyWith();
    } else {
      dossier = Dossier();
    }

    titleController.text = dossier!.name ?? '';
    _selectedDevise = dossier!.devise;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DossierBloc, DossierState>(
      listener: (context, state) async {
        if (EasyLoading.isShow) {
          await EasyLoading.dismiss();
        }
        if (state is DossiersLoading) {
          await EasyLoading.show(
            dismissOnTap: false,
            indicator: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text(
                  'Loading',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            maskType: EasyLoadingMaskType.black,
          );
        } else if (state is DossiersLoaded) {
          synchroNavigatorKey.currentContext!
              .read<SyncBloc>()
              .add(LoadDatabaseStats());
          Navigator.pop(context);
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        // child: WillPopScope(
        //   onWillPop: () {
        //     Map<String, dynamic> map = dossier.toJson();
        //     map.addAll({'status': isEdited});
        //     clientNavigatorKey.currentState.pop(map);
        //     return Future.value(true);
        //   },
        child: ScaffoldHeader(
          backgroundColor: AppColor.appSecondaryBackground,
          title: 'Dossier',
          showBackButton: true,
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 25,
                          ),
                          CustomTextField(
                            controller: titleController,
                            initalValue: dossier!.name ?? '',
                            labelText: 'Titre',
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return 'Obligatoire';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                dossier!.name = value;
                              });
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          BlocBuilder<DeviseBloc, DeviseState>(
                              builder: (context, snap) {
                            if (snap is DevisesLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snap is DevisesLoaded) {
                              return DropdownButtonFormField2<String>(
                                value: _selectedDevise,
                                style: AppThemes.bodyGreyTextStyle.copyWith(
                                    color: AppColor.appSecondaryColor),
                                decoration: InputDecoration(
                                  label: Text(
                                    'Devise',
                                    style: AppThemes.bodyGreyTextStyle.copyWith(
                                        color: AppColor.appSecondaryColor),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  isDense: true,
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                      color: AppColor.appSecondaryColor,
                                    ),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide:
                                        const BorderSide(color: Colors.red),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                        color: AppColor.appPrimaryColor),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: const BorderSide(
                                        color: AppColor.appPrimaryColor),
                                  ),
                                ),
                                isExpanded: true,
                                iconStyleData: IconStyleData(
                                    iconSize: 32,
                                    icon: const Icon(
                                        Icons.keyboard_arrow_down_outlined)),
                                buttonStyleData: ButtonStyleData(
                                    height: 50,
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10)),
                                dropdownStyleData: DropdownStyleData(
                                    maxHeight: 250,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0))),
                                items: snap.devises
                                    .map((item) => DropdownMenuItem<String>(
                                          value: item.nom,
                                          child: Text(item.nom!),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    dossier!.devise = value;
                                    _selectedDevise = value;
                                  });
                                },
                                onSaved: (value) {},
                                validator: (p0) {
                                  if (p0 == null || p0.isEmpty) {
                                    return 'Obligatoire';
                                  }
                                  return null;
                                },
                              );
                            } else {
                              return const Center(
                                child: Text('Erreur devises'),
                              );
                            }
                          }),
                        ],
                      ),
                    ),
                  ),
                  ButtonRaised(
                    title: 'Enregistrer',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (widget.dossier != null) {
                          context
                              .read<DossierBloc>()
                              .add(UpdateDossier(dossier!));
                        } else {
                          dossier!.createdAt = DateTime.now();
                          dossier!.archiver = false;
                          dossier!.idClient = widget.client!.id;
                          dossier!.statusFolder = true;
                          context.read<DossierBloc>().add(AddDossier(dossier!));
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        // ),
      ),
    );
  }
}
