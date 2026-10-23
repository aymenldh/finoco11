import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/core/models/devise.dart';
import 'package:finoco/core/shared/widgets/button_raised.dart';
import 'package:finoco/core/shared/widgets/custom_textfield.dart';
import 'package:finoco/features/devise/bloc/devise_bloc.dart';
import 'package:finoco/features/devise/bloc/devise_event.dart';
import 'package:finoco/features/devise/bloc/devise_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class AddDeviseDialog extends StatelessWidget {
  AddDeviseDialog({Key? key}) : super(key: key);
  final devisesTEC = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocListener<DeviseBloc, DeviseState>(
      listener: (context, state) async {
        if (EasyLoading.isShow) {
          await EasyLoading.dismiss();
        }
        if (state is DevisesLoading) {
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
        } else if (state is DevisesLoaded) {
          Navigator.pop(context);
        }
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        scrollable: true,
        content: Form(
          key: formKey,
          child: SizedBox(
            height: 230,
            child: Column(
              children: [
                const Text(
                  'Ajouter devise',
                  style: AppThemes.sectionTitleTextStyle,
                ),
                const SizedBox(
                  height: 50,
                ),
                CustomTextField(
                  controller: devisesTEC,
                  validator: (v) {
                    if (v!.isEmpty) {
                      return 'required';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 35,
                ),
                Row(
                  children: [
                    ButtonRaised(
                      title: 'Annuler',
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    ButtonRaised(
                      title: 'Enregistrer',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          context
                              .read<DeviseBloc>()
                              .add(AddDevise(Devise(nom: devisesTEC.text)));
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
