import 'package:finoco/config/network/exception_translation.dart';
import 'package:finoco/config/theme/colors.dart';
import 'package:finoco/config/theme/theme.dart';
import 'package:finoco/core/authentication_bloc/authentication_bloc.dart';
import 'package:finoco/core/repository/local_storage.dart';
import 'package:finoco/core/shared/widgets/button_raised.dart';
import 'package:finoco/core/shared/widgets/custom_textfield.dart';
import 'package:finoco/core/shared/widgets/scaffold_header.dart';
import 'package:finoco/core/shared/widgets/social_media.dart';
import 'package:finoco/features/auth/login/screens/login_screen.dart';
import 'package:finoco/features/auth/register/bloc/register_bloc.dart';
import 'package:finoco/features/auth/register/bloc/register_event.dart';
import 'package:finoco/features/auth/register/bloc/register_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:validators/validators.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool obscureTextPassword = true;
  bool obscureTextConfirmPassword = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  RegisterBloc? _registerBloc;
  final _formKey = GlobalKey<FormState>();
  bool passwordValid = false;

  @override
  void initState() {
    super.initState();
    _registerBloc = RegisterBloc();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: BlocProvider<RegisterBloc>(
        create: (context) => _registerBloc!,
        child: ScaffoldHeader(
          showBackButton: false,
          backgroundColor: AppColor.appSecondaryBackground,
          title: "Nouveau compte ?",
          bottomNavbar: Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                    offset: const Offset(0, -4),
                    blurRadius: 15,
                    spreadRadius: 0,
                    color: const Color(0xffCDCDCD).withOpacity(.4)),
              ],
            ),
            child: ButtonRaised(
              title: "Let's GO !",
              onPressed: _onFormSubmitted,
            ),
          ),
          child: BlocListener<RegisterBloc, RegisterState>(
            listener: (context, state) async {
              if (EasyLoading.isShow) {
                await EasyLoading.dismiss();
              }
              if (state.isSubmitting) {
                await EasyLoading.show(
                  dismissOnTap: false,
                  indicator: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircularProgressIndicator(),
                      SizedBox(height: 20),
                      SelectableText(
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
              if (state.isSuccess) {
                _handleSignUpSucceeds(context, state);
              }
              if (state.isFailure) {
                handleRegistrationFailed(context, state);
              }
            },
            child: BlocBuilder<RegisterBloc, RegisterState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: SelectableText(
                        'finoco',
                        style: AppThemes.widgetsTitleTextStyle
                            .copyWith(fontSize: 18),
                      ),
                    ),
                    Expanded(
                      child: AutofillGroup(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Form(
                            key: _formKey,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  SizedBox(
                                    height: 250,
                                    child: Image.asset('assets/finance_ill.jpg',
                                        fit: BoxFit.cover),
                                  ),
                                  CustomTextField(
                                    labelText: 'E-mail',
                                    keyboardType: TextInputType.emailAddress,
                                    autofillHints: const [AutofillHints.email],
                                    textInputAction: TextInputAction.next,
                                    controller: _emailController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'requiredField';
                                      }
                                      if (!isEmail(value!)) {
                                        return 'emailInvalidError';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  CustomTextField(
                                    labelText: 'Mot de passe',
                                    autofillHints: const [
                                      AutofillHints.password
                                    ],
                                    textInputAction: TextInputAction.next,
                                    controller: _passwordController,
                                    validator: (value) {
                                      return null;
                                    },
                                    obscureText: obscureTextPassword,
                                    type: "password",
                                    onPressed: () {
                                      setState(() {
                                        obscureTextPassword =
                                            !obscureTextPassword;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  CustomTextField(
                                    labelText: 'Confirmer Mot de passe',
                                    onEditingComplete: () =>
                                        TextInput.finishAutofillContext(),
                                    autofillHints: const [
                                      AutofillHints.password
                                    ],
                                    textInputAction: TextInputAction.done,
                                    controller: _confirmPasswordController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'requiredField';
                                      }
                                      if (value!.length < 8) {
                                        return 'passwordInvalidError';
                                      }
                                      if (value != _passwordController.text) {
                                        return 'confirmPasswordlInvalidError';
                                      }
                                      return null;
                                    },
                                    obscureText: obscureTextConfirmPassword,
                                    type: "password",
                                    onPressed: () {
                                      setState(() {
                                        obscureTextConfirmPassword =
                                            !obscureTextConfirmPassword;
                                      });
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  InkWell(
                                    child: Text(
                                      'Déjâ client ?',
                                      style:
                                          AppThemes.bodyGreyTextStyle.copyWith(
                                        color: AppColor.appPrimaryColor,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginScreen()),
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignUpSucceeds(
    BuildContext context,
    RegisterState state,
  ) async {
    BlocProvider.of<AuthenticationBloc>(context)
        .add(LoggedIn("", accessToken: ''));
    Navigator.pushReplacementNamed(context, '/');
  }

  Future<void> handleRegistrationFailed(
      BuildContext context, RegisterState state) async {
    Widget continueButton = TextButton(
      child: const Text('ok'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    CupertinoAlertDialog alert = CupertinoAlertDialog(
      title: const SelectableText(
        'warning',
        style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black),
      ),
      content: ExceptionTranslation(code: state.failureCode),
      actions: [
        continueButton,
      ],
    );
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> _onFormSubmitted() async {
    if (_formKey.currentState!.validate()) {
      _registerBloc!.add(
        Submitted(
          registrationType: 'email',
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    TextEditingController().dispose();
    super.dispose();
  }
}
