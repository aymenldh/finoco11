import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/core/models/client.dart';
import 'package:finoco/core/shared/widgets/button_raised.dart';
import 'package:finoco/core/shared/widgets/custom_textfield.dart';
import 'package:finoco/core/shared/widgets/scaffold_header.dart';
import 'package:finoco/features/clients/bloc/client_bloc.dart';
import 'package:finoco/features/clients/bloc/client_event.dart';
import 'package:finoco/features/clients/bloc/client_state.dart';
import 'package:finoco/features/synchro/bloc/sync_bloc.dart';
import 'package:finoco/features/synchro/bloc/sync_event.dart';
import 'package:finoco/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddClientScreen extends StatefulWidget {
  final Client? client;
  const AddClientScreen({Key? key, this.client}) : super(key: key);

  @override
  State<AddClientScreen> createState() => _AddClientScreenState();
}

class _AddClientScreenState extends State<AddClientScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final notesController = TextEditingController();
  GlobalKey formkey = GlobalKey<FormState>();
  bool isEdited = false;

  bool didUpdate = true;
  Client? client;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    if (widget.client != null) {
      client = widget.client!.copyWith();
    } else {
      client = Client();
    }
    firstNameController.text = client!.firstName ?? '';
    lastNameController.text = client!.lastName ?? '';
    emailController.text = client!.email ?? '';
    addressController.text = client!.address ?? '';
    phoneController.text = client!.phone ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ClientBloc, ClientState>(
      listener: (context, state) async {
        if (EasyLoading.isShow) {
          await EasyLoading.dismiss();
        }
        if (state is ClientsLoading) {
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
        } else if (state is ClientsLoaded) {
          synchroNavigatorKey.currentContext!
              .read<SyncBloc>()
              .add(LoadDatabaseStats());
          clientNavigatorKey.currentState!.pop();
        }
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        // child: WillPopScope(
        //   onWillPop: () {
        //     Map<String, dynamic> map = client.toJson();
        //     map.addAll({'status': isEdited});
        //     clientNavigatorKey.currentState.pop(map);
        //     return Future.value(true);
        //   },
        child: ScaffoldHeader(
            backgroundColor: AppColor.appSecondaryBackground,
            // customBackButtonCallBack: () {
            //   Map<String, dynamic> map = client.toJson();

            //   map.addAll({'status': isEdited});
            //   context.read<HomeBloc>().add(
            //         SetNavBarButton(null),
            //       );
            //   Navigator.pop(context, map);
            // },
            title: widget.client != null ? 'Modifier Client' : 'Ajout client',
            showBackButton: true,
            child: Form(
              key: formkey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
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
                            Row(
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    initalValue: client!.firstName ?? '',
                                    labelText: 'Prénom',
                                    onChanged: (value) {
                                      setState(() {
                                        client!.firstName = value;
                                      });
                                    },
                                    controller: firstNameController,
                                    validator: (v) {
                                      if (v!.isEmpty) {
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
                                  child: CustomTextField(
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    initalValue: client!.lastName ?? '',
                                    labelText: 'Nom',
                                    onChanged: (value) {
                                      setState(() {
                                        client!.lastName = value;
                                      });
                                    },
                                    validator: (v) {
                                      if (v!.isEmpty) {
                                        return 'Obligatoire';
                                      }
                                      return null;
                                    },
                                    controller: lastNameController,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                              initalValue: client!.email ?? '',
                              labelText: 'E-mail',
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                setState(() {});
                                client!.email = value;
                              },
                              controller: emailController,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                              controller: addressController,
                              initalValue: client!.address ?? '',
                              labelText: 'Adresse',
                              onChanged: (value) {
                                setState(() {
                                  client!.address = value;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            CustomTextField(
                              initalValue: client!.phone ?? '',
                              labelText: 'Téléphone',
                              onChanged: (value) {
                                setState(() {
                                  client!.phone = value;
                                });
                              },
                              controller: phoneController,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                              initalValue: client!.notes ?? '',
                              labelText: 'Remarques',
                              controller: notesController,
                              isTextArea: true,
                              onChanged: (v) {
                                client!.notes = v;
                              },
                              minlines: 5,
                              maxlines: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    ButtonRaised(
                      title: 'Enregistrer',
                      onPressed: () {
                        if (widget.client != null) {
                          context.read<ClientBloc>().add(UpdateClient(client!));
                        } else {
                          client!.createdAt = DateTime.now();
                          client!.archiver = false;
                          context.read<ClientBloc>().add(AddClient(client!));
                        }
                      },
                    ),
                  ],
                ),
              ),
            )),
        // ),
      ),
    );
  }
}
