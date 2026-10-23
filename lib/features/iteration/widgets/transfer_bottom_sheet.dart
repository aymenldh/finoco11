import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/core/models/client.dart';
import 'package:finoco/core/models/dossier.dart';
import 'package:finoco/core/models/type_transaction.dart';
import 'package:finoco/core/shared/widgets/button_raised.dart';
import 'package:finoco/core/shared/widgets/custom_search_field.dart';
import 'package:finoco/core/shared/widgets/custom_textfield.dart';
import 'package:finoco/features/accueil/stats/stats_bloc.dart';
import 'package:finoco/features/accueil/stats/stats_event.dart';
import 'package:finoco/features/clients/bloc/client_bloc.dart';
import 'package:finoco/features/clients/bloc/client_event.dart';
import 'package:finoco/features/clients/bloc/client_state.dart';
import 'package:finoco/features/dossiers/bloc/dossier_bloc.dart';
import 'package:finoco/features/dossiers/bloc/dossier_event.dart';
import 'package:finoco/features/dossiers/bloc/dossier_state.dart';
import 'package:finoco/features/iteration/bloc/iteration_bloc.dart';
import 'package:finoco/features/iteration/bloc/iteration_event.dart';
import 'package:finoco/features/iteration/bloc/iteration_state.dart';
import 'package:finoco/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TransferButtomSheet extends StatefulWidget {
  final int? idIteration;
  final TypeTransaction? typeTransaction;
  final int? idDossier;
  final int? idClient;
  const TransferButtomSheet(
      {Key? key,
      this.idIteration,
      this.typeTransaction,
      this.idDossier,
      this.idClient})
      : super(key: key);

  @override
  State<TransferButtomSheet> createState() => _TransferButtomSheetState();
}

class _TransferButtomSheetState extends State<TransferButtomSheet> {
  TextEditingController searchTEC = TextEditingController();
  ClientBloc clientBloc = ClientBloc();
  DossierBloc dossierBloc = DossierBloc();
  IterationBloc iterationBloc = IterationBloc();
  Client? selectedOption;
  Dossier? _selectedDossier;
  int currentScreen = 0;
  TypeTransaction? _selectedComponent;
  FocusNode myFocusNode = FocusNode();

  bool _isTextFieldFocused = false;

  @override
  void initState() {
    _selectedComponent = widget.typeTransaction;
    myFocusNode.addListener(() {
      setState(() {
        _isTextFieldFocused = myFocusNode.hasFocus;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DossierBloc>(
          create: (context) => dossierBloc,
        ),
        BlocProvider<ClientBloc>(
          create: (context) => clientBloc,
        ),
        BlocProvider<IterationBloc>(
          create: (context) => iterationBloc,
        ),
      ],
      child: BlocListener<IterationBloc, IterationState>(
        listener: (context, state) async {
          if (EasyLoading.isShow) {
            await EasyLoading.dismiss();
          }
          if (state is IterationsLoading) {
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
          } else if (state is IterationsLoaded) {
            clientNavigatorKey.currentContext!
                .read<ClientBloc>()
                .add(LoadClients(''));
            clientNavigatorKey.currentContext!
                .read<DossierBloc>()
                .add(LoadDossiers(true, widget.idClient!));
            accueilNavigatorKey.currentContext!
                .read<StatsBloc>()
                .add(LoadStats());
            clientNavigatorKey.currentContext!.read<IterationBloc>().add(
                LoadIterations(widget.typeTransaction!.name, widget.idDossier!));

            Navigator.pop(context);
          }
        },
        child: Container(
          decoration: const BoxDecoration(
            color: AppColor.appPrimaryBackground,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
              bottomLeft: Radius.elliptical(-25, -25),
              bottomRight: Radius.elliptical(-25, -25),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2, bottom: 10),
                width: 100,
                height: 8,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.appPrimaryColor),
              ),
              const Text(
                'Transférer',
                style: AppThemes.sectionTitleTextStyle,
              ),
              currentScreen == 0 ? _showSearchScreen() : _showDropDownMenus()
            ],
          ),
        ),
      ),
    );
  }

  Column _showSearchScreen() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: CustomSearchField(
            focusNode: myFocusNode,
            controller: searchTEC,
            borderColor: Colors.grey,
            onChanged: (v) {
              clientBloc.add(SearchForTransfert(v));
            },
            suffix: _isTextFieldFocused! || searchTEC.text.isNotEmpty
                ? Icons.close
                : null,
            onPressed: () {
              setState(() {
                searchTEC.clear();
              });
              clientBloc.add(SearchForTransfert(''));
              FocusScope.of(context).requestFocus(FocusNode());
            },
            icon: const Icon(
              Icons.search,
            ),
            hintText: 'Rechercher client',
          ),
        ),
        BlocBuilder<ClientBloc, ClientState>(
          bloc: clientBloc,
          builder: (context, state) {
            if (state is ClientsLoaded) {
              return Column(
                children: state.client
                    .map(
                      (e) => ListTile(
                        onTap: () {
                          setState(() {
                            selectedOption = e;
                            dossierBloc.add(
                                LoadDossierForTransfert(selectedOption!.id!));
                          });
                        },
                        title: Text(e.fullName),
                        leading: Radio<Client>(
                          value: e,
                          groupValue: selectedOption,
                          onChanged: (value) {
                            setState(() {
                              selectedOption = value;
                              dossierBloc.add(
                                  LoadDossierForTransfert(selectedOption!.id!));
                            });
                          },
                        ),
                      ),
                    )
                    .toList(),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
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
              enabled: selectedOption != null,
              title: 'Suivant',
              onPressed: () {
                setState(() {
                  currentScreen = 1;
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  _showDropDownMenus() {
    return Column(
      children: [
        BlocBuilder<DossierBloc, DossierState>(
          bloc: dossierBloc,
          builder: (context, state) {
            if (state is DossiersLoaded) {
              return DropdownButtonFormField2<Dossier>(
                scrollbarAlwaysShow: false,
                value: _selectedDossier,
                style: AppThemes.bodyGreyTextStyle
                    .copyWith(color: AppColor.appSecondaryColor),
                decoration: InputDecoration(
                  label: Text(
                    'Dossier',
                    style: AppThemes.bodyGreyTextStyle
                        .copyWith(color: AppColor.appSecondaryColor),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
                    borderSide: const BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide:
                        const BorderSide(color: AppColor.appPrimaryColor),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide:
                        const BorderSide(color: AppColor.appPrimaryColor),
                  ),
                ),
                isExpanded: true,
                buttonHeight: 50,
                buttonPadding: const EdgeInsets.only(left: 10, right: 10),
                dropdownDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.0),
                ),
                dropdownMaxHeight: 250,
                items: state.dossiers
                    .map((item) => DropdownMenuItem<Dossier>(
                          value: item,
                          child: Text(
                            item.name!,
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDossier = value;
                  });
                },
                icon: const Icon(Icons.keyboard_arrow_down),
                validator: (p0) {
                  if (p0 == null) {
                    return 'requiredField';
                  }
                  return null;
                },
              );
            } else {
              return CustomTextField(
                controller: TextEditingController(),
                labelText: 'Dossiers',
                suffix: Icons.keyboard_arrow_down,
                enabled: false,
              );
            }
          },
        ),
        const SizedBox(
          height: 25,
        ),
        DropdownButtonFormField2<TypeTransaction>(
          scrollbarAlwaysShow: false,
          value: _selectedComponent,
          style: AppThemes.bodyGreyTextStyle
              .copyWith(color: AppColor.appSecondaryColor),
          decoration: InputDecoration(
            label: Text(
              'Type transaction',
              style: AppThemes.bodyGreyTextStyle
                  .copyWith(color: AppColor.appSecondaryColor),
            ),
            filled: true,
            fillColor: Colors.white,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
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
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: const BorderSide(color: AppColor.appPrimaryColor),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: BorderSide.none,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0),
              borderSide: const BorderSide(color: AppColor.appPrimaryColor),
            ),
          ),
          isExpanded: true,
          iconSize: 32,
          icon: const Icon(Icons.keyboard_arrow_down_outlined),
          buttonHeight: 50,
          buttonPadding: const EdgeInsets.only(left: 10, right: 10),
          dropdownDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
          ),
          dropdownMaxHeight: 250,
          items: TypeTransaction.values
              .map((item) => DropdownMenuItem<TypeTransaction>(
                    value: item,
                    child: Text(item.name),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedComponent = value;
            });
          },
          onSaved: (value) {
            setState(() {
              _selectedComponent = value;
            });
          },
          validator: (p0) {
            if (p0 == null) {
              return 'Obligatoire';
            }
            return null;
          },
        ),
        ButtonBar(
          alignment: MainAxisAlignment.end,
          children: [
            ButtonRaised(
              title: 'Annuler',
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(
              width: 10,
            ),
            ButtonRaised(
              title: 'Précédent',
              onPressed: () {
                setState(() {
                  currentScreen = 0;
                });
              },
            ),
            const SizedBox(
              width: 10,
            ),
            ButtonRaised(
              enabled: selectedOption != null && _selectedDossier != null,
              title: 'Transférer',
              onPressed: () {
                iterationBloc.add(TransfereIteration(widget.idIteration!,
                    _selectedDossier!.id!, _selectedComponent!));
              },
            ),
          ],
        ),
      ],
    );
  }
}
