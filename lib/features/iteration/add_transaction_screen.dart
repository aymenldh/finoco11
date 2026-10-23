import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/core/models/attachements.dart';
import 'package:finoco/core/models/dossier.dart';
import 'package:finoco/core/models/iteration.dart';
import 'package:finoco/core/models/type_transaction.dart';
import 'package:finoco/core/shared/widgets/button_raised.dart';
import 'package:finoco/core/shared/widgets/custom_textfield.dart';
import 'package:finoco/core/shared/widgets/scaffold_header.dart';
import 'package:finoco/features/accueil/stats/stats_bloc.dart';
import 'package:finoco/features/accueil/stats/stats_event.dart';
import 'package:finoco/features/clients/bloc/client_bloc.dart';
import 'package:finoco/features/clients/bloc/client_event.dart';
import 'package:finoco/features/devise/bloc/devise_bloc.dart';
import 'package:finoco/features/devise/bloc/devise_event.dart';
import 'package:finoco/features/dossiers/bloc/dossier_bloc.dart';
import 'package:finoco/features/dossiers/bloc/dossier_event.dart';
import 'package:finoco/features/dossiers/widgets/dossier_totale_widget.dart';
import 'package:finoco/features/iteration/attachements_bloc/attachements_bloc.dart';
import 'package:finoco/features/iteration/attachements_bloc/attachements_event.dart';
import 'package:finoco/features/iteration/attachements_bloc/attachements_state.dart';
import 'package:finoco/features/iteration/bloc/iteration_bloc.dart';
import 'package:finoco/features/iteration/bloc/iteration_event.dart';
import 'package:finoco/features/iteration/bloc/iteration_state.dart';
import 'package:finoco/features/synchro/bloc/sync_bloc.dart';
import 'package:finoco/features/synchro/bloc/sync_event.dart';
import 'package:finoco/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddTransactonScreen extends StatefulWidget {
  final Iteration iteration;
  final Dossier dossier;
  final TypeTransaction typeTransaction;
  const AddTransactonScreen(
      {Key key, this.iteration, this.dossier, this.typeTransaction})
      : super(key: key);

  @override
  State<AddTransactonScreen> createState() => _AddTransactonScreenState();
}

class _AddTransactonScreenState extends State<AddTransactonScreen> {
  final rateController = TextEditingController();
  final amountController = TextEditingController();
  final amountDeviseController = TextEditingController();
  final titleController = TextEditingController();
  final notesController = TextEditingController();

  List<Attachements> pjs = [];
  Iteration iteration;
  final _formKey = GlobalKey<FormState>();
  String _selectedOperation;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();

    if (widget.iteration != null) {
      iteration = widget.iteration.copyWith();
    } else {
      iteration = Iteration();
    }
    iteration.devise = widget.dossier.devise;
    rateController.text =
        iteration.taux != null ? iteration.taux.toStringAsFixed(0) : '';
    amountController.text = iteration.amountTND != null
        ? iteration.amountTND.toStringAsFixed(0)
        : '';
    amountDeviseController.text = iteration.amountDevise != null
        ? iteration.amountDevise.toStringAsFixed(0)
        : '';
    titleController.text = iteration.name ?? '';
    notesController.text = iteration.description ?? '';
    iteration.type = widget.typeTransaction;
    _selectedOperation = iteration.operation;
    context.read<AttachementsBloc>().add(LoadAttachementss(iteration.id));
  }

  Future<FilePickerResult> pickFile() async {
    return await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
  }

  Future<FilePickerResult> pickPhoto() async {
    return await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
  }

  Future<void> uploadAndSaveFile() async {
    final result = await pickFile();

    if (result != null && result.files.isNotEmpty) {
      final filePath = result.files.single.path;
      final fileName = result.files.single.name;

      // Upload the file and get the download URL
      if (widget.iteration != null) {
        context
            .read<AttachementsBloc>()
            .add(AddAttachements(filePath, fileName, widget.iteration.id));
      } else {
        setState(() {
          pjs.add(Attachements(
            name: fileName,
            url: filePath,
          ));
        });
      }
    }
  }

  Future<void> uploadAndSavePhoto() async {
    final result = await pickPhoto();

    if (result != null && result.files.isNotEmpty) {
      final filePath = result.files.single.path;
      final fileName = result.files.single.name;

      // Upload the file and get the download URL
      if (widget.iteration != null) {
        context
            .read<AttachementsBloc>()
            .add(AddAttachements(filePath, fileName, widget.iteration.id));
      } else {
        setState(() {
          pjs.add(Attachements(
            name: fileName,
            url: filePath,
          ));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<IterationBloc, IterationState>(
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
              clientNavigatorKey.currentContext
                  .read<ClientBloc>()
                  .add(LoadClients(''));
              clientNavigatorKey.currentContext.read<DossierBloc>().add(
                  LoadDossiers(
                      widget.dossier.statusFolder, widget.dossier.idClient));
              accueilNavigatorKey.currentContext
                  .read<StatsBloc>()
                  .add(LoadStats());
              synchroNavigatorKey.currentContext
                  .read<SyncBloc>()
                  .add(LoadDatabaseStats());
              Navigator.pop(context);
            }
          },
        ),
        BlocListener<AttachementsBloc, AttachementsState>(
          listener: (context, state) async {
            if (EasyLoading.isShow) {
              await EasyLoading.dismiss();
            }
            if (state is AttachementssLoading) {
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
            }
          },
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: ScaffoldHeader(
          backgroundColor: AppColor.appSecondaryBackground,
          title: widget.typeTransaction == TypeTransaction.PAIEMENT
              ? 'Paiement'
              : 'Service',
          showBackButton: true,
          titleLineWidget: ButtonRaised(
            title: 'OK',
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                if (iteration.devise == 'TND') {
                  iteration.amountDevise = iteration.amountTND;
                }
                if (widget.iteration != null) {
                  context
                      .read<IterationBloc>()
                      .add(UpdateIteration(iteration, pjs));
                } else {
                  iteration.idFolder = widget.dossier.id;
                  iteration.createdAt = DateTime.now();
                  iteration.idClient = widget.dossier.idClient;
                  if (iteration.devise != 'TND') {
                    iteration.amountTND = double.parse(amountController.text);
                  }
                  context
                      .read<IterationBloc>()
                      .add(AddIteration(iteration, pjs));
                }
              }
            },
          ),
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DossierTotaleWidget(
                      isAddIteration: true,
                      dossier: widget.dossier,
                    ),
                    CustomTextField(
                      controller: titleController,
                      labelText: 'Titre',
                      onChanged: (value) {
                        setState(() {
                          iteration.name = value;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Obligatoire';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextField(
                      labelText: 'Montant TND',
                      keyboardType: const TextInputType.numberWithOptions(
                          signed: false, decimal: true),
                      onChanged: (value) {
                        setState(() {});
                        iteration.amountTND = double.parse(value);
                      },
                      controller: amountController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Obligatoire';
                        }
                        return null;
                      },
                    ),
                    if (widget.dossier.devise != 'TND') ...[
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Devise : ' + widget.dossier.devise,
                        style: AppThemes.bigTextStyle,
                      ),
                      CustomTextField(
                        keyboardType: const TextInputType.numberWithOptions(
                            signed: false, decimal: true),
                        formatter: [
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                        ],
                        textInputAction: TextInputAction.next,
                        labelText: 'Montant devise',
                        onChanged: (value) {
                          setState(() {
                            iteration.amountDevise = double.parse(value);
                            if (iteration.taux != null &&
                                iteration.amountDevise != null &&
                                _selectedOperation != null &&
                                _selectedOperation.isNotEmpty) {
                              if (_selectedOperation == '/') {
                                setState(() {
                                  iteration.amountTND =
                                      iteration.amountDevise / iteration.taux;
                                  amountController.text =
                                      iteration.amountTND.toStringAsFixed(0);
                                });
                              } else {
                                setState(() {
                                  iteration.amountTND =
                                      iteration.taux * iteration.amountDevise;
                                  amountController.text =
                                      iteration.amountTND.toStringAsFixed(0);
                                });
                              }
                            }
                          });
                        },
                        validator: (value) {
                          if ((value == null || value.isEmpty) &&
                              iteration.devise != 'TND') {
                            return 'Obligatoire';
                          }
                          return null;
                        },
                        controller: amountDeviseController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField2(
                              scrollbarAlwaysShow: false,
                              value: _selectedOperation,
                              style: AppThemes.bodyGreyTextStyle
                                  .copyWith(color: AppColor.appSecondaryColor),
                              decoration: InputDecoration(
                                label: Text(
                                  'Opération',
                                  style: AppThemes.bodyGreyTextStyle.copyWith(
                                      color: AppColor.appSecondaryColor),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                              iconSize: 32,
                              icon: const Icon(
                                  Icons.keyboard_arrow_down_outlined),
                              buttonHeight: 50,
                              buttonPadding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              dropdownDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              dropdownMaxHeight: 250,
                              items: ['/', '*']
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedOperation = value;
                                  iteration.operation = value;
                                });
                                if (iteration.taux != null &&
                                    iteration.amountDevise != null &&
                                    _selectedOperation != null &&
                                    _selectedOperation.isNotEmpty) {
                                  if (_selectedOperation == '/') {
                                    iteration.amountTND =
                                        iteration.amountDevise / iteration.taux;
                                    amountController.text =
                                        iteration.amountTND.toStringAsFixed(0);
                                  } else {
                                    iteration.amountTND =
                                        iteration.amountDevise * iteration.taux;
                                    amountController.text =
                                        iteration.amountTND.toStringAsFixed(0);
                                  }
                                }
                              },
                              onSaved: (value) {},
                              validator: (p0) {
                                if (p0 == null || p0.isEmpty) {
                                  return 'Obligatoire';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 2,
                            child: CustomTextField(
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: false, decimal: true),
                              textInputAction: TextInputAction.next,
                              formatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[0-9,]')),
                              ],
                              labelText: 'Taux',
                              onChanged: (value) {
                                setState(() {
                                  iteration.taux =
                                      double.parse(value.replaceAll(',', "."));
                                  if (iteration.taux != null &&
                                      iteration.amountDevise != null &&
                                      _selectedOperation != null &&
                                      _selectedOperation.isNotEmpty) {
                                    if (_selectedOperation == '/') {
                                      iteration.amountTND =
                                          iteration.amountDevise /
                                              iteration.taux;
                                      amountController.text = iteration
                                          .amountTND
                                          .toStringAsFixed(0);
                                    } else {
                                      iteration.amountTND = iteration.taux *
                                          iteration.amountDevise;
                                      amountController.text = iteration
                                          .amountTND
                                          .toStringAsFixed(0);
                                    }
                                  }
                                });
                              },
                              validator: (value) {
                                if ((value == null || value.isEmpty) &&
                                    iteration.devise != 'TND') {
                                  return 'Obligatoire';
                                }
                                return null;
                              },
                              controller: rateController,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(
                      height: 20,
                    ),
                    CustomTextField(
                      initalValue: iteration.description ?? '',
                      labelText: 'Remarques',
                      controller: notesController,
                      isTextArea: true,
                      minlines: 5,
                      maxlines: 10,
                      onChanged: (v) {
                        setState(() {
                          iteration.description = v;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Pièces jointes : ',
                            style: AppThemes.titleTextStyle,
                          ),
                        ),
                        IconButton(
                          onPressed: uploadAndSaveFile,
                          icon: const Icon(
                            Icons.attach_file,
                            color: AppColor.appSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                    BlocBuilder<AttachementsBloc, AttachementsState>(
                      builder: (context, state) {
                        if (state is AttachementssLoaded) {
                          pjs = state.attachements;
                          return ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            children: pjs
                                .map(
                                  (item) => Card(
                                    child: ListTile(
                                      leading: Icon(
                                        item.type != 'pdf'
                                            ? Icons.image
                                            : Icons.picture_as_pdf,
                                        color: item.type != 'pdf'
                                            ? AppColor.appPrimaryColor
                                            : AppColor.appSecondaryColor,
                                      ),
                                      title: Text(item.name,
                                          style: AppThemes.kbirShwyTextStyle),
                                      trailing: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            pjs.remove(item);
                                          });
                                        },
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.red,
                                        ),
                                      ),
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
                      },
                    ),
                  ],
                ),
                // ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> initIteration() async {
    // pjs = iteration.id == null
    //     ? []
    //     : await DatabaseHelper.instance
    //         .getAttachmentsByIdIteration(iteration.id);
    // notesController.text = iteration.description;
  }
}
